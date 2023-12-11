import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Playlists {
  List<List<Video>> playlists = [];

  void addPlaylist(List<Video> playlist) {
    playlists.add(playlist);
  }

  List<Video> getPlaylist (int index) {
    return playlists.elementAt(index);
  }
}
