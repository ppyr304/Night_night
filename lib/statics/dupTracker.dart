
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DupTracker{
  Set<VideoId> fetchedVideoIds = <VideoId>{};
  Set<ChannelId> fetchedChannelIds = <ChannelId>{};
  Set<PlaylistId> fetchedPlaylistIds = <PlaylistId>{};

  void clearVideos () {
    fetchedVideoIds.clear();
  }
  void clearChannels () {
    fetchedVideoIds.clear();
  }
  void clearPlaylists () {
    fetchedVideoIds.clear();
  }
  void clearAll () {
    clearVideos();
    clearChannels();
    clearPlaylists();
  }
}