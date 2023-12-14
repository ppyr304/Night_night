import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {super.key,
      required this.video,
      required this.index,
      required this.curr});
  final Video video;
  final int index;
  final int curr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (curr == index)
            ? const Icon(
                Icons.arrow_right,
                color: Colors.red,
              )
            : Text((index + 1).toString()),
        Expanded(
          child: ListTile(
            leading: Image.network(video.thumbnails.maxResUrl),
            title: Text(video.title),
            subtitle: Text(
              video.author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
