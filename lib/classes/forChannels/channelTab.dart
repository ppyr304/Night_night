import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forVideos/videoCard.dart';

class ChannelTab extends StatelessWidget {
  final List<Video> videos;
  const ChannelTab({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return VideoCard(item: videos[index]);
      },
    );
  }
}
