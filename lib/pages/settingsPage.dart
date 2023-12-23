import 'package:flutter/material.dart';
import 'package:youtube_player/counters.dart';

import '../classes/forSettings/settingsFuncs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String limitTooltip =
      'Sets the maximum videos/duration before closing the app.';

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
              mainAxisAlignment: MainAxisAlignment.center,
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
            DurationField(),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {},
              child: const Text('set video limit'),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
