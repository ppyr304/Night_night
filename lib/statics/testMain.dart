import 'package:flutter/material.dart';

import '../classes/forChannels/channelCard.dart';
import '../classes/forPlaylist/playlistCard.dart';
import '../classes/forVideos/videoCard.dart';
import '../classes/others/searchData.dart';
import 'APIService.dart';
import 'dupTracker.dart';

class TestMain extends StatefulWidget {
  const TestMain({super.key, required this.title});

  final String title;

  @override
  State<TestMain> createState() => _TestMainState();
}

class _TestMainState extends State<TestMain>
    with SingleTickerProviderStateMixin {
  late TabController _mainTabController;
  final vidcontroller = ScrollController();
  final chacontroller = ScrollController();
  final placontroller = ScrollController();

  SearchData sd = SearchData();

  var editor = TextEditingController();
  final FocusNode _node = FocusNode();
  int filter = 0;

  List<String> presets_1 = [
    "Enter Video Name...",
    "Enter Channel Name...",
    "Enter Playlist Name...",
  ];

  //search funcs
  Future<String> searchVideos() async {
    int length = sd.videoList.length;
    var videoPool =
        await APIService.instance.getSearchedVideos(sd.searchQuery, sd);
    for (var video in videoPool) {
      sd.videoList.add(video);
    }

    if (length == sd.videoList.length) {
      DupTracker.instance.videoLimitReached;
    }
    return "video search finished";
  }

  Future<String> searchChannels() async {
    int length = sd.channelList.length;
    var channelPool =
        await APIService.instance.getSearchedChannels(sd.searchQuery, sd);

    for (var channel in channelPool) {
      sd.channelList.add(channel);
    }

    if (length == sd.channelList.length) {
      DupTracker.instance.channelLimitReached;
    }
    return "channel search finished";
  }

  Future<String> searchPlaylists() async {
    int length = sd.playlistList.length;
    // sd.playlistList
    //     .addAll(await APIService.instance.fetchPlaylist(sd.searchQuery));
    var playlistToAdd = await APIService.instance.fetchPlaylist(sd.searchQuery);

    for (var playlist in playlistToAdd) {
      sd.playlistList.add(playlist);
    }

    if (length == sd.playlistList.length) {
      DupTracker.instance.playlistLimitReached;
      return 'limit reached';
    } else {
      return await getPlaylistPic();
    }
  }

  Future<String> getPlaylistPic() async {
    for (int x = 0; x < sd.playlistList.length; x++) {
      sd.firstVids.add(await APIService.instance
          .getFirstVideo(sd.playlistList[x].id.toString()));
    }
    return "playlist search finished";
  }

  Future<void> initSearch() async {
    sd.vdata = searchVideos();
    sd.cdata = searchChannels();
    sd.pdata = searchPlaylists();
  }

  Future<void> search() async {
    _node.unfocus();
    sd.clearList();
    APIService.instance.resetTracker();

    await initSearch();
  }

  //other funcs
  void setFilter(int num) {
    setState(() {
      filter = num;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);

    vidcontroller.addListener(() {
      if (vidcontroller.position.maxScrollExtent == vidcontroller.offset &&
          DupTracker.instance.videoLimitReached == false) {
        setState(() {
          searchVideos();
        });
      }
    });
    chacontroller.addListener(() {
      if (chacontroller.position.maxScrollExtent == chacontroller.offset &&
          DupTracker.instance.channelLimitReached == false) {
        setState(() {
          searchChannels();
        });
      }
    });
    placontroller.addListener(() {
      if (placontroller.position.maxScrollExtent == placontroller.offset &&
          DupTracker.instance.playlistLimitReached == false) {
        setState(() {
          searchPlaylists();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            tooltip: "settings",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).canvasColor,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        cursorColor: Theme.of(context).canvasColor,
                        style: const TextStyle(),
                        controller: editor,
                        focusNode: _node,
                        decoration: InputDecoration(
                          hintText: presets_1[filter],
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            sd.searchQuery = value;
                          });
                        },
                        onEditingComplete: () {
                          search();
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
                          sd.searchQuery = "";
                          editor.clear();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: const Icon(Icons.search_rounded),
                      onTap: () {
                        search();
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                )),
            const SizedBox(height: 10),
            TabBar(
                onTap: (index) {
                  setFilter(index);
                },
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
                  FutureBuilder(
                      future: sd.vdata,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: vidcontroller,
                            itemCount: sd.videoList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < sd.videoList.length) {
                                return VideoCard(
                                  item: sd.videoList[index],
                                );
                              } else {
                                if ((DupTracker.instance.videoLimitReached)) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Couldn't find more"),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
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
                      future: sd.cdata,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: chacontroller,
                            itemCount: sd.channelSearchList!.length + 1,
                            itemBuilder: (context, index) {
                              if (index < sd.channelSearchList!.length) {
                                return ChannelCard(
                                  item: sd.channelList[index],
                                );
                              } else {
                                if ((DupTracker.instance.channelLimitReached)) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Couldn't find more"),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
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
                      future: sd.pdata,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: placontroller,
                            itemCount: sd.playlistList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < sd.playlistList.length) {
                                return PlaylistCard(
                                  playlist: sd.playlistList[index],
                                  firstVideo: sd.firstVids[index],
                                );
                              } else {
                                if ((DupTracker
                                    .instance.playlistLimitReached)) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Couldn't find more"),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
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
