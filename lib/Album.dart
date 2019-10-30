import 'package:flutter_app/SongInfo.dart';

class Album {
  final List<SongInfo> songs;
  final String name;
  String artist;
  Album(this.songs, this.name,[this.artist]);
}