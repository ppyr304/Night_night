import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forVideos/videoCard.dart';

import '../forChannels/channelCard.dart';
import '../forPlaylist/playlistCard.dart';

class MyTabViewItem extends StatelessWidget {
  final Future<String>? data;
  final List list;
  final List? list2;
  const MyTabViewItem(
      {super.key, required this.data, required this.list, this.list2});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list.first;

                if (item is Video) {
                  return VideoCard(
                    item: list[index],
                  );
                }
                if (item is Channel) {
                  return ChannelCard(
                    item: list[index],
                  );
                }
                if (item is Playlist) {
                  return PlaylistCard(
                    playlist: list[index],
                    firstVideo: list2?[index],
                  );
                }
                return null;
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        });
  }
}
