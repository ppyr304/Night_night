
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class OVLData{
  VideoSearchList? vsl;
  List<Video> videos = [];

  void dispose() {
    vsl?.clear();
    videos.clear();
  }
}