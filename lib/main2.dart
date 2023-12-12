import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/statics/Futures.dart';

import 'classes/forChannels/channelCard.dart';
import 'classes/forPlaylist/playlistCard.dart';
import 'classes/forVideos/videoCard.dart';
import 'classes/others/mainTabView.dart';
import 'statics/APIService.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key, required this.title});

  final String title;

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> with SingleTickerProviderStateMixin {
  late TabController _mainTabController;

  Future<String>? data;
  String searchQuery = "";
  List<Video> _VideoList = [];
  List<Channel> _ChannelList = [];
  List<Playlist> _PlaylistList = [];
  List<Video> _firstVids = [];
  var editor = TextEditingController();
  int filter = 0;
  List<String> presets_1 = [
    "Enter Video Name...",
    "Enter Channel Name...",
    "Enter Playlist Name...",
  ];

  List<Text> presets_2 = [
    const Text("find video"),
    const Text("find channel"),
    const Text("find playlist"),
  ];

  String selectedItem = 'videos';

  //search funcs
  Future<String> searchVideos() async {
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

    return "video search finished";
  }

  Future<String> searchChannels() async {
    _ChannelList = await APIService.instance.getAllChannels(searchQuery);

    return "channel search finished";
  }

  Future<String> searchPlaylists() async {
    _PlaylistList = await APIService.instance.fetchPlaylist(searchQuery);

    return await filler();
  }

  Future<String> filler() async {
    await Future.wait(_PlaylistList.map((playlist) async {
      Video temp =
          await APIService.instance.getFirstVideo(playlist.id.toString());
      _firstVids.add(temp);
    }));

    return "playlist search finished";
  }

  Future<String> search() async {
    List<Future<String>> futures = [
      searchVideos(),
      searchChannels(),
      searchPlaylists(),
    ];

    await Future.wait(futures);

    return "All searches completed";
  }

  void setFilter(int num) {
    setState(() {
      filter = num;
    });
  }

  int getLength() {
    if (filter == 0) {
      return _VideoList.length;
    } else if (filter == 1) {
      return _ChannelList.length;
    } else if (filter == 2) {
      return _PlaylistList.length;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<String> ddItems = ['videos', 'channels', 'playlists'];
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: lightTertiary),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        cursorColor: lightTertiary,
                        style: TextStyle(color: lightTertiary),
                        controller: editor,
                        decoration: InputDecoration(
                          hintText: presets_1[filter],
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        onEditingComplete: () {
                          data = search();
                          setState(() {});
                        },
                      ),
                    )),
                    GestureDetector(
                      child: const Icon(
                        Icons.clear_rounded,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          searchQuery = "";
                          editor.clear();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: const Icon(Icons.search_rounded),
                      onTap: () {
                        data = search();
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                )),
            const SizedBox(height: 10),
            TabBar(
                controller: _mainTabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'videos'),
                  Tab(text: 'channels'),
                  Tab(text: 'playlists'),
                ]),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  // MyTabViewItem(
                  //   data: data,
                  //   list: _VideoList,
                  // ),
                  // MyTabViewItem(
                  //   data: data,
                  //   list: _ChannelList,
                  // ),
                  // MyTabViewItem(
                  //   data: data,
                  //   list: _PlaylistList,
                  //   list2: _firstVids,
                  // ),

                  FutureBuilder(
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: _VideoList.length,
                            itemBuilder: (context, index) {
                              return VideoCard(
                                item: _VideoList[index],
                              );
                            },
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  FutureBuilder(
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: _ChannelList.length,
                            itemBuilder: (context, index) {
                              return ChannelCard(
                                item: _ChannelList[index],
                              );
                            },
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  FutureBuilder(
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: _PlaylistList.length,
                            itemBuilder: (context, index) {
                              return PlaylistCard(
                                playlist: _PlaylistList[index],
                                firstVideo: _firstVids[index],
                              );
                            },
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
