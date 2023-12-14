import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forPlaylist/playlistTile.dart';

void buildSheet(BuildContext context, List<Video> playlist, int curr) {
  showBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            return PlaylistTile(video: playlist[index], index: index, curr: curr,);
          },
        ),
      );
    },
  );
}
