import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/Playlists.dart';

class ChannelData {
  Channel? channel;
  int totalVideoCount = 0;
  List<int> videoCounts = [];
  List<String> playlistIds = [];
  Playlists playlists = Playlists();

  ChannelData({required this.channel});
}
