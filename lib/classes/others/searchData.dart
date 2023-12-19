
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchData{
  Future<String>? vdata;
  Future<String>? cdata;
  Future<String>? pdata;

  String searchQuery = "";

  List<Video> videoList = [];
  List<Channel> channelList = [];
  List<Playlist> playlistList = [];
  List<Video> firstVids = [];

  VideoSearchList? videoSearchList;
  SearchList? channelSearchList;
  SearchList? playlistSearchList;

  bool videoLimitReached = false;
  bool channelLimitReached = false;
  bool playlistLimitReached = false;

  void resetList() {
    videoList.clear();
    channelList.clear();
    playlistList.clear();
    firstVids.clear();

    videoSearchList?.clear();
    channelSearchList?.clear();
    playlistSearchList?.clear();

    resetLimitV();
    resetLimitC();
    resetLimitP();
  }

  void dispose () {
    vdata = null;
    cdata = null;
    pdata = null;

    searchQuery = '';

    videoList.clear();
    channelList.clear();
    playlistList.clear();
    firstVids.clear();

    videoSearchList?.clear();
    channelSearchList?.clear();
    playlistSearchList?.clear();

    resetLimitV();
    resetLimitC();
    resetLimitP();
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
}