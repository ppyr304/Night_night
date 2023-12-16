import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
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
    sd.videoList.addAll(await APIService.instance.getAllVideos(sd.searchQuery));

    // Set your target date, for example, the current date and time
    DateTime targetDate = DateTime.now();

    sd.videoList.sort((a, b) {
      if (a.uploadDate == null && b.uploadDate == null) {
        return 0;
      } else if (a.uploadDate == null) {
        return 1; // Move items with null DateTime to the end
      } else if (b.uploadDate == null) {
        return -1; // Move items with null DateTime to the end
      } else {
        var x = b.uploadDate!.difference(targetDate);
        var y = a.uploadDate!.difference(targetDate);
        return x.compareTo(y);
      }
    });

    if (length == sd.videoList.length) {
      DupTracker.instance.videoLimitReached;
    }
    setState(() {});
    return "video search finished";
  }

  Future<String> searchChannels() async {
    int length = sd.channelList.length;
    sd.channelList.addAll(await APIService.instance.getAllChannels(sd.searchQuery));

    if (length == sd.channelList.length) {
      DupTracker.instance.channelLimitReached;
    }
    setState(() {});
    return "channel search finished";
  }

  Future<String> searchPlaylists() async {
    int length = sd.playlistList.length;
    sd.playlistList.addAll(await APIService.instance.fetchPlaylist(sd.searchQuery));

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
    setState(() {});
    return "playlist search finished";
  }

  Future<void> initSearch () async {
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
        searchVideos();
      }
    });
    chacontroller.addListener(() {
      if (chacontroller.position.maxScrollExtent == chacontroller.offset &&
          DupTracker.instance.channelLimitReached == false) {
        searchChannels();
      }
    });
    placontroller.addListener(() {
      if (placontroller.position.maxScrollExtent == placontroller.offset &&
          DupTracker.instance.playlistLimitReached == false) {
        searchPlaylists();
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
                        style: const TextStyle(color: lightTertiary),
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
                            controller: placontroller,
                            itemCount: sd.playlistList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < sd.playlistList.length) {
                                return PlaylistCard(
                                  playlist: sd.playlistList[index],
                                  firstVideo: sd.firstVids[index],
                                );
                              } else {
                                if ((DupTracker.instance.playlistLimitReached)) {
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
