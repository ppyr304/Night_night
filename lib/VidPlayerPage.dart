import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/classes/others/otherVideoList.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VidPlayerPage extends StatefulWidget {
  final String playlistId;
  final Video item;
  final bool isPlaylist;
  const VidPlayerPage(
      {super.key,
      required this.isPlaylist,
      required this.item,
      required this.playlistId});

  @override
  State<VidPlayerPage> createState() => _VidPlayerPageState();
}

class _VidPlayerPageState extends State<VidPlayerPage> {
  late Future<YoutubePlayerController> ytController;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    ytController = getController();
  }

  Future<YoutubePlayerController> getController() async {
    YoutubePlayerController yt = YoutubePlayerController(
      initialVideoId: widget.item.id.toString(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        loop: true,
      ),
    );

    setState(() {
      ready = true;
    });
    return yt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (ready)
          ? FutureBuilder(
              future: ytController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                      ),
                      controller: snapshot.data!,
                      showVideoProgressIndicator: true,
                      onEnded: (ytContext) {
                        exit(0);
                      },
                    ),
                    builder: (BuildContext, player) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: player),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.item.title,
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.item.author,
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.thumb_up_alt_rounded),
                                Icon(Icons.thumb_down_alt_rounded),
                                Text(
                                  timeAgo(widget.item.uploadDate),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          Expanded(
                            child: OtherVideoList(
                              query: (widget.isPlaylist == true)
                                  ? widget.playlistId
                                  : widget.item.title,
                              isPlaylist: widget.isPlaylist,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("An Error has Occured:\n${snapshot.error}");
                } else {
                  return Container();
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
