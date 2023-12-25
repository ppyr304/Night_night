import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class Storage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getLocalFile(String fileName) async {
    final localPath = await _localPath;
    return File('$localPath/$fileName');
  }

  static Future<File> writeToFile(String text) async {
    final file = await _getLocalFile('night^2_limitSaves');

    return file.writeAsString(text);
  }

  static Future<String> readFromFile() async {
    String temp = '';
    File? file;
    try {
      file = await _getLocalFile('night^2_limitSaves');
      temp = await file.readAsString();
    } catch (error) {
      log('${DateTime.now()}, at readFromFile, $error');
      log('creating a new file called night^2_limitSaves');

      String text = '1\n'
          '0 30 0';

      await writeToFile(text);
      file = await _getLocalFile('night^2_limitSaves');
      temp = await file.readAsString();
      log(file.path);
    }

    if (temp.isNotEmpty) {
      var lines = temp.split('\n');
      for (var line in lines) {
        var datas = line.split(' ');
        for (var data in datas) {
          print(data);
        }
      }
    }

    return temp;
  }
}
