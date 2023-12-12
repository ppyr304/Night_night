import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../VidPlayerPage.dart';

class PlaylistCard extends StatefulWidget {
  final Video firstVideo;
  final Playlist playlist;
  const PlaylistCard(
      {super.key, required this.playlist, required this.firstVideo});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
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
                  child: Image(
                    image:
                        NetworkImage(widget.firstVideo.thumbnails.highResUrl),
                  ),
                ),
              ),
            ),
            ListTile(
              isThreeLine: true,
              title: Text(
                widget.playlist.title,
                style: TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("by ${widget.playlist.author}"),
                  Text("${widget.playlist.videoCount} videos"),
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
                playlist: widget.playlist,
                item: widget.firstVideo,
                isPlaylist: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
