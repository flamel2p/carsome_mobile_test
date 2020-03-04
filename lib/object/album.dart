import 'package:carsome_mobile_test/libraries/value_provider.dart';
import 'package:carsome_mobile_test/api/key_name.dart';

class Album {
  final int albumID;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  String get albumIDInString => albumID.toString();
  String get idInString => albumID.toString();

  Album({this.albumID, this.id, this.title, this.url, this.thumbnailUrl});

  factory Album.fromMap(Map albumMap) {
    final ValueProvider album = ValueProvider(albumMap);

    final int _albumID = album.getInt(kAlbumID);
    int _id = album.getInt(kID);
    String _title = album.getString(kTitle);
    String _url = album.getString(kUrl);
    String _thumbnailUrl = album.getString(kThumbnailUrl);

    return Album(
        albumID: _albumID,
        id: _id,
        title: _title,
        url: _url,
        thumbnailUrl: _thumbnailUrl);
  }
}

class AlbumList {
  final List<Album> albumns;

  int get length => albumns.length;

  AlbumList(this.albumns);

  factory AlbumList.fromList(List<Map> albumList) {
    final List<Album> _albums = albumList.map((a) => Album.fromMap(a)).toList();

    return AlbumList(_albums);
  }
}
