import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../statics/APIService.dart';

class PlaylistData {
  String playlistID = '';
  String thumbnail = '';
  List<Video> videos = [];
  int curr = 0;

  PlaylistData._instantiate();

  static final PlaylistData instance = PlaylistData._instantiate();

  PlaylistData({required this.playlistID});

  void fetchData() async {
    videos = await APIService.instance.fetchPlaylistVideos(playlistID);

    thumbnail = videos[0].thumbnails.maxResUrl;
  }
}
