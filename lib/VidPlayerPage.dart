import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/assets/constants.dart';
import 'package:youtube_player/classes/forPlaylist/playlistData.dart';
import 'package:youtube_player/classes/others/otherVideoList.dart';
import 'package:youtube_player/statics/APIService.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'classes/forPlaylist/botSheetList.dart';

class VidPlayerPage extends StatefulWidget {
  const VidPlayerPage(
      {super.key,
      required this.isPlaylist,
      this.item,
      this.playlist,
      this.curr,
      this.playlistVideos});

  final Playlist? playlist;
  final Video? item;
  final bool isPlaylist;
  final int? curr;
  final List<Video>? playlistVideos;

  @override
  State<VidPlayerPage> createState() => _VidPlayerPageState();
}

class _VidPlayerPageState extends State<VidPlayerPage> {
  late Future<YoutubePlayerController> ytController;
  late PlaylistData pdata;
  List<Video> allVids = [];
  bool ready = false;
  bool show = false;

  Future<void> fetchPlaylistVideo() async {
    allVids = await APIService.instance
        .fetchPlaylistVideos(widget.playlist!.id.toString());

    setState(() {
      pdata.playlistVideos = allVids;
      pdata.ready = true;
    });
  }

  @override
  void initState() {
    super.initState();
    ytController = getController();
    if (widget.playlistVideos == null) {
      fetchPlaylistVideo();
    } else {
      allVids = widget.playlistVideos!;
    }

    pdata = PlaylistData(
      playlist: widget.playlist!,
      item: widget.item!,
      playlistVideos: allVids,
      curr: widget.curr!,
    );

    setState(() {
      ready = true;
    });
  }

  Future<YoutubePlayerController> getController() async {
    YoutubePlayerController yt = YoutubePlayerController(
      initialVideoId: widget.item!.id.toString(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        loop: false,
      ),
    );

    return yt;
  }

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
                          if (widget.playlist != null) {
                            if (widget.curr == pdata.playlistVideos.length-1) {
                              exit(0);
                            } else {
                              int next = widget.curr! + 1;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VidPlayerPage(
                                        isPlaylist: true,
                                        item: allVids[next],
                                        playlist: widget.playlist,
                                        curr: next,
                                      )));
                            }
                          } else {
                            exit(0);
                          }
                        },
                      ),
                      builder: (context, player) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            player,
                            ListTile(
                              tileColor: Theme.of(context).primaryColor,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              title: Text(
                                widget.item!.title,
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
                                timeAgo(widget.item!.uploadDate),
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
                                  Expanded(
                                    child: ListTile(
                                      tileColor: Theme.of(context).primaryColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 0,
                                      ),
                                      title: Text(
                                        widget.item!.author,
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
                                  ),
                                  if (widget.isPlaylist)
                                    OutlinedButton(
                                      onPressed: (pdata.ready == true)
                                          ? () {
                                              show = !show;
                                              if (show == true) {
                                                buildSheet(context, pdata);
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                              setState(() {});
                                            }
                                          : null,
                                      child: const Text('show playlist'),
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
                                query: widget.item!.title,
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
