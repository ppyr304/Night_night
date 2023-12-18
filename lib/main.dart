import 'package:flutter/material.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/classes/forPlaylist/playlistCard.dart';
import 'package:youtube_player/statics/dupTracker.dart';
import 'classes/forChannels/channelCard.dart';
import 'classes/forVideos/videoCard.dart';
import 'classes/others/searchData.dart';
import 'statics/APIService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'youtube player?',
      theme: CustomLightTheme(),
      darkTheme: CustomDarkTheme(),
      home: const HomePage(title: 'Night Night'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _mainTabController;

  final vidController = ScrollController();
  final chaController = ScrollController();
  final plaController = ScrollController();

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
    var videoPool = await APIService.instance.getSearchedVideos(sd);
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
    var channelPool = await APIService.instance.getSearchedChannels(sd);

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
    var playlistToAdd = await APIService.instance.getSearchedPlaylists(sd);

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

    vidController.addListener(() {
      if (vidController.position.maxScrollExtent == vidController.offset &&
          DupTracker.instance.videoLimitReached == false) {
        setState(() {
          searchVideos();
        });
      }
    });
    chaController.addListener(() {
      if (chaController.position.maxScrollExtent == chaController.offset &&
          DupTracker.instance.channelLimitReached == false) {
        setState(() {
          searchChannels();
        });
      }
    });
    plaController.addListener(() {
      if (plaController.position.maxScrollExtent == plaController.offset &&
          DupTracker.instance.playlistLimitReached == false) {
        setState(() {
          searchPlaylists();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    APIService.instance.dispose();
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
                            controller: vidController,
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
                            controller: chaController,
                            itemCount: sd.channelList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < sd.channelList.length) {
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
                            controller: plaController,
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
