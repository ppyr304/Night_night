import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_player/classes/forSettings/counters.dart';

class Storage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getLocalFile(String fileName) async {
    final localPath = await _localPath;
    return File('$localPath/$fileName');
  }

  static Future<File> writeLimit(String text) async {
    final file = await _getLocalFile('night^2_limitSaves');

    return file.writeAsString(text);
  }

  static Future<String> readLimit() async {
    String temp = '';
    File? file;
    try {
      file = await _getLocalFile('night^2_limitSaves');
      temp = await file.readAsString();
    } catch (error) {
      log('${DateTime.now()}, at readFromFile, $error');
      log('--creating a new file called night^2_limitSaves');

      String text = '1\n'
          '0 30 0';

      await writeLimit(text);
      file = await _getLocalFile('night^2_limitSaves');
      temp = await file.readAsString();
      log('--${file.path}');
    }

    if (temp.isNotEmpty) {
      var lines = temp.split('\n');
      Counters.instance.maxVideos = int.tryParse(lines[0]) ?? 1;

      var data = lines[1].split(' ');
      int h = int.tryParse(data[0]) ?? 0;
      int m = int.tryParse(data[1]) ?? 30;
      int s = int.tryParse(data[2]) ?? 0;
      Duration d = Duration(hours: h, minutes: m, seconds: s);
      Counters.instance.maxDuration = d;
    }

    return temp;
  }
}
