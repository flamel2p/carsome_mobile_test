import 'dart:async';
import 'dart:convert';
import 'package:carsome_mobile_test/object/album.dart';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:carsome_mobile_test/api/key_name.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final String _scheme = 'https';
  final String _host = 'jsonplaceholder.typicode.com';
  final String _path = '/photos';

  final Client http = Client();

  int currentAlbumID = 1;

  @override
  get initialState => AlbumListUninitialized();

  @override
  Stream<AlbumListState> mapEventToState(AlbumListEvent event) async* {
    try {
      if (event is Fetch) {
        currentAlbumID = event.albumID;
        yield await _fetch(currentAlbumID);
        return;
      }

      if (event is Refresh) {
        yield AlbumListUninitialized();
        yield await _fetch(currentAlbumID);
        return;
      }

      throw 'Unknown AlbumListEvent.';
    } catch (e) {
      yield AlbumListError(e);
    }
  }

  Future<AlbumListState> _fetch(int albumID) async {
    try {
      final Map<String, dynamic> _params = <String, dynamic>{
        kAlbumID: albumID.toString()
      };

      final Uri _uri = Uri(
          scheme: _scheme, host: _host, path: _path, queryParameters: _params);

      final Response response = await http.get(_uri);

      if (response.statusCode != 200) {
        throw 'Load Failed.';
      }

      final result = json.decode(response.body);
      if (result is List) {
        final AlbumList _albumList = AlbumList.fromList(List<Map>.from(result));
        return AlbumListLoaded(_albumList);
      }

      throw 'Invalid Content.';
    } catch (e) {
      return AlbumListError('$e\nTry again later.');
    }
  }
}
