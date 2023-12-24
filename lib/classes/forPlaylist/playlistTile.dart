import 'package:flutter/material.dart';
import 'package:youtube_player/classes/forPlaylist/playlistData.dart';

import '../../pages/vidPlayerPage.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {super.key, required this.data, required this.index, required this.curr});

  final PlaylistData data;
  final int index;
  final int curr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (curr == index)
            ? const SizedBox(
                width: 28,
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.red,
                ),
              )
            : SizedBox(width: 17, child: Text((index + 1).toString())),
        Expanded(
          child: ListTile(
            leading:
                Image.network(data.playlistVideos[index].thumbnails.highResUrl),
            title: Text(data.playlistVideos[index].title),
            subtitle: Text(
              data.playlistVideos[index].author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VidPlayerPage(
                        isPlaylist: true,
                        item: data.playlistVideos[index],
                        playlist: data.playlist,
                        curr: index,
                      )));
            },
          ),
        ),
      ],
    );
  }
}
