import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forChannels/channelData.dart';
import 'package:youtube_player/classes/forChannels/uploadTab.dart';

import 'assets/constants.dart';
import 'statics/APIService.dart';

class ChannelPage extends StatefulWidget {
  final Channel item;
  const ChannelPage({super.key, required this.item});

  @override
  State<ChannelPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChannelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = ScrollController();

  Future<String>? data;
  late ChannelData channelData;
  bool reachedEnd = false;

  Future<void> _getChannelData() async {
    channelData = await APIService.instance.fetchChannelData(widget.item);

    if (channelData.uploads.isEmpty) {
      _getUploadsData();
    }

    data = Future.value("done");
  }

  Future<void> _getUploadsData() async {
    int before = channelData.uploads.length;
    await APIService.instance.fetchChannelUploads(channelData);
    int after = channelData.uploads.length;

    if (before == after) {
      reachedEnd = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getChannelData();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        _getUploadsData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _tabController.dispose();
    controller.dispose();
    reachedEnd = false;
    channelData.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30, // Adjust the radius of the circle avatar
                    backgroundImage: NetworkImage(widget.item.logoUrl),
                  ),
                  title: Text(
                    widget.item.title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        SubCount(widget.item.subscribersCount?.toDouble() ?? 0),
                      ),
                      Text(
                        '${channelData.totalVideoCount} videos uploaded',
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'uploads'),
                          Tab(text: 'playlists'),
                          Tab(text: 'description'),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              UploadTab(
                                uploads: channelData.uploads,
                                controller: controller,
                                reachedEnd: reachedEnd,
                              ),
                              const Center(
                                  child: Text('still under construction')),
                              ListView(
                                  children: [Text(channelData.description)]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
