import 'package:equatable/equatable.dart';

abstract class AlbumListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends AlbumListEvent {
  final int albumID;
  Fetch(this.albumID);
}

class Refresh extends AlbumListEvent {}
