import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../forVideos/videoCard.dart';

class UploadTab extends StatefulWidget {
  const UploadTab(
      {super.key,
      required this.uploads,
      required this.controller,
      required this.reachedEnd});

  final List<Video> uploads;
  final ScrollController controller;
  final bool reachedEnd;

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      itemCount: widget.uploads.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.uploads.length) {
          return VideoCard(
            item: widget.uploads[index],
          );
        } else {
          if ((widget.reachedEnd)) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("Couldn't find more")),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      },
    );
  }
}
