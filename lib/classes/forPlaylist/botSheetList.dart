import 'package:flutter/material.dart';
import 'package:youtube_player/classes/forPlaylist/playlistData.dart';
import 'package:youtube_player/classes/forPlaylist/playlistTile.dart';

void buildSheet(BuildContext context, PlaylistData data) {
  showBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
          itemCount: data.playlistVideos.length,
          itemBuilder: (context, index) {
            return PlaylistTile(
              data: data,
              index: index,
              curr: data.curr,
            );
          },
        ),
      );
    },
  );
}
