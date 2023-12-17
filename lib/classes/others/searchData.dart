
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchData{
  Future<String>? vdata;
  Future<String>? cdata;
  Future<String>? pdata;
  String searchQuery = "";
  List<Video> videoList = [];
  List<Channel> channelList = [];
  List<Playlist> playlistList = [];

  var videoSearchList;
  var channelSearchList;
  var playlistSearchList;

  List<Video> firstVids = [];

  void clearList() {
    videoList.clear();
    channelList.clear();
    playlistList.clear();
    firstVids.clear();
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
  }
}