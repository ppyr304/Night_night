import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/classes/others/otherVideoList.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VidPlayerPage extends StatefulWidget {
  const VidPlayerPage(
      {super.key, required this.isPlaylist, required this.item, this.playlist});

  final Playlist? playlist;
  final Video item;
  final bool isPlaylist;

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

  void bottSheet() {}

  @override
  Widget build(BuildContext context) {
    double ratio = 16 / 9;
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
                  return SafeArea(
                    child: YoutubePlayerBuilder(
                      onEnterFullScreen: () {
                        setState(() {
                          ratio = MediaQuery.of(context).size.height /
                              (MediaQuery.of(context).size.width * 0.75);
                          print(ratio);
                        });
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ]);
                      },
                      onExitFullScreen: () {
                        setState(() {
                          ratio = 16 / 9;
                        });
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      },
                      player: YoutubePlayer(
                        aspectRatio: ratio,
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
                            player,
                            ListTile(
                              tileColor: Theme.of(context).primaryColor,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              title: Text(
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
                              subtitle: Text(
                                timeAgo(widget.item.uploadDate),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
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
                                  if (widget.isPlaylist)
                                    OutlinedButton(
                                      child: const Text('show playlist'),
                                      onPressed: () {
                                        showBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                child: Text('data'),
                                              );
                                            });
                                      },
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(),
                            ),
                            Expanded(
                              child: OtherVideoList(
                                query: widget.item.title,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
