import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forVideos/videoCard.dart';
import 'package:youtube_player/classes/others/ovlData.dart';

import '../../statics/APIService.dart';

class OtherVideoList extends StatefulWidget {
  final String query;
  const OtherVideoList({super.key, required this.query});

  @override
  State<OtherVideoList> createState() => _OtherVideoListState();
}

class _OtherVideoListState extends State<OtherVideoList> {
  var controller = ScrollController();

  Future<String>? state;
  OVLData ovlData = OVLData();

  Future<void> getOtherVideos() async {
    await APIService.instance.fetchOtherVids(widget.query, ovlData);

    setState(() {
      state = Future.value('done');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (ovlData.videos.isEmpty) {
      getOtherVideos();
    }

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        getOtherVideos();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ovlData.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: state,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            controller: controller,
            itemCount: ovlData.videos.length,
            itemBuilder: (BuildContext context, int index) {
              return VideoCard(item: ovlData.videos[index]);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
