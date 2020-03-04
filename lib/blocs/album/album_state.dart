import 'package:equatable/equatable.dart';
import 'package:carsome_mobile_test/object/album.dart';

abstract class AlbumListState extends Equatable {
  const AlbumListState();

  @override
  List<Object> get props => [];
}

class AlbumListUninitialized extends AlbumListState {}

class AlbumListError extends AlbumListState {
  final String error;
  const AlbumListError(this.error);
}

class AlbumListLoaded extends AlbumListState {
  final AlbumList albumList;

  const AlbumListLoaded(this.albumList);

  @override
  List<Object> get props => [albumList];

  @override
  String toString() => 'AlbumListLoaded { length: ${albumList.length}';
}
