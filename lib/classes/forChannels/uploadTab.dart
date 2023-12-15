import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../forVideos/videoCard.dart';

class UploadTab extends StatefulWidget {
  const UploadTab({super.key, required this.uploads});

  final List<Video> uploads;

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.uploads.length,
      itemBuilder: (context, index) {
        return VideoCard(item: widget.uploads[index]);
      },
    );
  }
}
