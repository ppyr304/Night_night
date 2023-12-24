import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class Storage{
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getLocalFile (String fileName) async {
    final localPath = await _localPath;
    return File('$localPath/$fileName');
  }

  static Future<File> writeToFile (String text) async {
    final file = await _getLocalFile('counterSaves.txt');

    return file.writeAsString(text);
  }

  static Future<String> readFromFile () async {
    final file = await _getLocalFile('counterSaves.txt');
    print(file.path);
    return file.readAsString();
  }
}