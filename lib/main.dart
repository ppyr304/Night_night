import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/classes/forPlaylist/playlistCard.dart';
import 'package:youtube_player/statics/dupTracker.dart';
import 'classes/forChannels/channelCard.dart';
import 'classes/forVideos/videoCard.dart';
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

  Future<String>? data;
  String searchQuery = "";
  final List<Video> _VideoList = [];
  final List<Channel> _ChannelList = [];
  final List<Playlist> _PlaylistList = [];
  final List<Video> _firstVids = [];
  var editor = TextEditingController();
  final FocusNode _node = FocusNode();
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
    int length = _VideoList.length;
    _VideoList.addAll(await APIService.instance.getAllVideos(searchQuery));

    // Set your target date, for example, the current date and time
    DateTime targetDate = DateTime.now();

    _VideoList.sort((a, b) {
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

    if (length == _VideoList.length) {
      DupTracker.instance.videoLimitReached;
    }
    setState(() {});
    return "video search finished";
  }

  Future<String> searchChannels() async {
    int length = _ChannelList.length;
    _ChannelList.addAll(await APIService.instance.getAllChannels(searchQuery));

    if (length == _ChannelList.length) {
      DupTracker.instance.channelLimitReached;
    }
    print(_ChannelList.length);
    setState(() {});
    return "channel search finished";
  }

  Future<String> searchPlaylists() async {
    int length = _PlaylistList.length;
    _PlaylistList.addAll(await APIService.instance.fetchPlaylist(searchQuery));

    if (length == _PlaylistList.length) {
      DupTracker.instance.playlistLimitReached;
      return 'limit reached';
    } else {
      return await getPlaylistPic();
    }
  }

  Future<String> getPlaylistPic() async {
    for (int x = 0; x < _PlaylistList.length; x++) {
      _firstVids.add(await APIService.instance
          .getFirstVideo(_PlaylistList[x].id.toString()));
    }
    setState(() {});
    return "playlist search finished";
  }

  Future<String> search() async {
    _node.unfocus();

    _VideoList.clear();
    _ChannelList.clear();
    _PlaylistList.clear();
    _firstVids.clear();
    APIService.instance.resetTracker();

    List<Future<String>> futures = [
      searchVideos(),
      searchChannels(),
      searchPlaylists(),
    ];

    await Future.wait(futures);

    return "All searches completed";
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
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: vidcontroller,
                            itemCount: _VideoList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < _VideoList.length) {
                                return VideoCard(
                                  item: _VideoList[index],
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
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: chacontroller,
                            itemCount: _ChannelList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < _ChannelList.length) {
                                return ChannelCard(
                                  item: _ChannelList[index],
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
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: placontroller,
                            itemCount: _PlaylistList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < _PlaylistList.length) {
                                return PlaylistCard(
                                  playlist: _PlaylistList[index],
                                  firstVideo: _firstVids[index],
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
