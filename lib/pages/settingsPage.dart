import 'package:flutter/material.dart';
import 'package:youtube_player/classes/others/storage.dart';

import '../classes/forSettings/counters.dart';
import '../classes/forSettings/settingsWidgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String limitTooltip =
      'Sets the maximum videos/duration before closing the app.\n'
      '** 0 = unlimited videos / duration';

  void saveLimit () async {
    int n = Counters.instance.num;
    int h = Counters.instance.h;
    int m = Counters.instance.m;
    int s = Counters.instance.s;
    String limits = '$n\n$h $m $s';
    Storage.writeLimit(limits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Set Limit',
                  style: TextStyle(fontSize: 19),
                ),
                IconButton(
                  onPressed: () {
                    showLimitTooltip(context, limitTooltip);
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
            const VideoAmountField(),
            const SizedBox(height: 15),
            const DurationField(),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                Counters.instance.maxVideos = Counters.instance.num;
                Counters.instance.maxDuration = Counters.instance.dur;
                saveLimit();
              },
              child: const Text('save limit'),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
