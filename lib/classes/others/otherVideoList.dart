import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forVideos/videoCard.dart';

import '../../statics/APIService.dart';

class OtherVideoList extends StatefulWidget {
  final String query;
  const OtherVideoList(
      {super.key, required this.query});

  @override
  State<OtherVideoList> createState() => _OtherVideoListState();
}

class _OtherVideoListState extends State<OtherVideoList> {
  List<Video> videos = [];

  Future<void> getOtherVideos() async {
    videos = await APIService.instance.fetchOtherVids(widget.query);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOtherVideos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }
}
