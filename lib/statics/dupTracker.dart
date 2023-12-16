
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DupTracker{
  DupTracker._instantiate();

  static final DupTracker instance = DupTracker._instantiate();

  Set<VideoId> fetchedVideoIds = <VideoId>{};
  Set<ChannelId> fetchedChannelIds = <ChannelId>{};
  Set<PlaylistId> fetchedPlaylistIds = <PlaylistId>{};
  bool videoLimitReached = false;
  bool channelLimitReached = false;
  bool playlistLimitReached = false;

  void clearVideos () {
    fetchedVideoIds.clear();
  }
  void clearChannels () {
    fetchedVideoIds.clear();
  }
  void clearPlaylists () {
    fetchedVideoIds.clear();
  }

  void reachedVideoLimit () {
    videoLimitReached = true;
  }
  void reachedChannelLimit () {
    channelLimitReached = true;
  }
  void reachedPlaylistLimit () {
    playlistLimitReached = true;
  }
  void resetLimitV () {
    videoLimitReached = false;
  }
  void resetLimitC () {
    channelLimitReached = false;
  }
  void resetLimitP () {
    playlistLimitReached = false;
  }

  void resetAll () {
    clearVideos();
    clearChannels();
    clearPlaylists();
    resetLimitV();
    resetLimitC();
    resetLimitP();
  }
}