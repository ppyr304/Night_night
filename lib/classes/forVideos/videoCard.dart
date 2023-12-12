import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/VidPlayerPage.dart';
import 'package:youtube_player/assets/constants.dart';

class VideoCard extends StatelessWidget {
  final Video item;
  const VideoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
      child: GestureDetector(
        child: Column(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: 0.75,
                child: Container(
                  child: Image(image: NetworkImage(item.thumbnails.highResUrl)),
                ),
              ),
            ),
            ListTile(
              isThreeLine: true,
              title: Text(
                item.title,
                style: TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.author}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${formatDuration(item.duration)} | ${timeAgo(item.uploadDate)}'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VidPlayerPage(
                item: item,
                isPlaylist: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
