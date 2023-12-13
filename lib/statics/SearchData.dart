import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'APIService.dart';

class SearchData {
  String searchQuery = "";
  Future<String>? state;

  List<Video> _VideoList = [];
  List<Channel> _ChannelList = [];
  List<Playlist> _PlaylistList = [];
  List<Video> _firstVids = [];

  SearchData._instantiate();

  static final SearchData instance = SearchData._instantiate();

  void searchVideos() async {
    _VideoList = await APIService.instance.getAllVideos(searchQuery);

    // // Set your target date, for example, the current date and time
    // DateTime targetDate = DateTime.now();
    //
    // _VideoList.sort((a, b) {
    //   if (a.uploadDate == null && b.uploadDate == null) {
    //     return 0;
    //   } else if (a.uploadDate == null) {
    //     return 1; // Move items with null DateTime to the end
    //   } else if (b.uploadDate == null) {
    //     return -1; // Move items with null DateTime to the end
    //   } else {
    //     var x = a.uploadDate!.compareTo(targetDate);
    //     var y = b.uploadDate!.compareTo(targetDate);
    //     return x.compareTo(y);
    //   }
    // });
    //
    // _VideoList.forEach((item) {
    //   print(timeAgo(item.uploadDate));
    // });
  }

  void searchChannels() async {
    _ChannelList = await APIService.instance.getAllChannels(searchQuery);
  }

  void searchPlaylists() async {
    _PlaylistList = await APIService.instance.fetchPlaylist(searchQuery);
    filler();
  }

  void filler() async {
    await Future.wait(_PlaylistList.map((playlist) async {
      Video temp =
          await APIService.instance.getFirstVideo(playlist.id.toString());
      _firstVids.add(temp);
    }));
  }

  Future<String> startSearch() async {
    try {
      searchVideos();
      searchChannels();
      searchPlaylists();

      return "All searches completed";
    } catch (error) {
      return "Search disrupted, error: $error";
    }
  }
}
