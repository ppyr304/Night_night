import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({super.key, required this.video, required this.index});
  final Video video;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Image.network(video.thumbnails.maxResUrl),
      ),
      title: Text(video.title),
      subtitle: Text(
        video.author,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Text(index.toString()),
    );
  }
}
