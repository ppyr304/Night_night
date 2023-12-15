import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forChannels/channelData.dart';

import 'assets/constants.dart';
import 'classes/forChannels/channelTab.dart';
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

  late ChannelData channelData;

  Future<void> _getChannelData() async {
    channelData = await APIService.instance.fetchChannelData(widget.item);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _getChannelData(),
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
                        SubCount(
                            widget.item.subscribersCount?.toDouble() ?? 0),
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
                          Tab(text: 'recent uploads'),
                          Tab(text: 'something'),
                          Tab(text: 'else'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ChannelTab(
                              videos: channelData.playlists.getPlaylist(0),
                            ),
                            const Center(child: Text('still under')),
                            const Center(child: Text('construction')),
                          ],
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
