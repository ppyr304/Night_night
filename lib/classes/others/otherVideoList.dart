import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forVideos/videoCard.dart';

import '../../statics/APIService.dart';

class OtherVideoList extends StatefulWidget {
  final String query;
  final bool isPlaylist;
  const OtherVideoList(
      {super.key, required this.query, required this.isPlaylist});

  @override
  State<OtherVideoList> createState() => _OtherVideoListState();
}

class _OtherVideoListState extends State<OtherVideoList> {
  List<Video> videos = [];

  Future<void> getOtherVideos() async {
    if (widget.isPlaylist) {
      videos = await APIService.instance.fetchPlaylistVideos(widget.query);
    } else {
      videos = await APIService.instance.fetchOtherVids(widget.query);
    }

    videos.forEach((element) {
      print(element.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: getOtherVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(item: videos[index]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
