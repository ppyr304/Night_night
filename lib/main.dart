import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/classes/forPlaylist/playlistCard.dart';
import 'package:youtube_player/classes/others/mainTabView.dart';
import 'package:youtube_player/main2.dart';
import 'classes/forChannels/channelCard.dart';
import 'classes/forVideos/videoCard.dart';
import 'statics/APIService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'youtube player?',
      theme: CustomLightTheme(),
      darkTheme: CustomDarkTheme(),
      home: const Home2(title: 'Night Night'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
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

    // Set your target date, for example, the current date and time
    DateTime targetDate = DateTime.now();

    _VideoList.sort((a, b) => (a.uploadDate!.difference(targetDate))
        .abs()
        .compareTo(b.uploadDate!.difference(targetDate).abs()));

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

    print('done');
    return "playlist search finished";
  }

  Future<void> search() async {
    setState(() {
      data = searchVideos();
      data = searchChannels();
      data = searchPlaylists();
    });
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
                  border: Border.all(color: Theme.of(context).canvasColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: editor,
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: Theme.of(context).canvasColor),
                          hintText: presets_1[filter],
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Theme.of(context).canvasColor),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        onEditingComplete: () {
                          search();
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
                        search();
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
                child: FutureBuilder(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return TabBarView(
                    controller: _mainTabController,
                    children: [
                      // MyTabViewItem(list: _VideoList),
                      // MyTabViewItem(list: _ChannelList),
                      // MyTabViewItem(list: _PlaylistList, list2: _firstVids),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
