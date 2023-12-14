import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../statics/APIService.dart';

class PlaylistData {
  Playlist playlist;
  Video item;
  int curr;
  List<Video> playlistVideos;
  bool ready = false;

  PlaylistData(
      {required this.playlist,
      required this.item,
      required this.playlistVideos,
      required this.curr});
}
