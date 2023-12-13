import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forPlaylist/playlistTile.dart';

void buildSheet(BuildContext context, Future<List<Video>> data) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              List<Video>? playlist = snapshot.data;

              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: playlist!.length,
                  itemBuilder: (context, index) {
                    return PlaylistTile(video: playlist[index], index: index);
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(child: Text('Error loading playlist'));
              }
            },
          ),
        );
      });
}
