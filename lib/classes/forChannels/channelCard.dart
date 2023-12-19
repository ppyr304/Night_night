import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forChannels/channelData.dart';

import '../../ChannelPage.dart';
import '../../assets/constants.dart';
import '../../statics/APIService.dart';

class ChannelCard extends StatelessWidget {
  final Channel item;
  const ChannelCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.logoUrl),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          SubCount(item.subscribersCount?.toDouble() ?? 0),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChannelPage(item: item),
            ),
          );
        },
      ),
    );
  }
}
