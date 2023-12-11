import 'dart:convert';
import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forChannels/channelData.dart';
import 'package:http/http.dart' as http;

import 'keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String baseURL = "https://www.googleapis.com/youtube/v3/";
  String _PageToken = '';

  Future<List<Channel>> getAllChannels(String query) async {
    final ytExplode = YoutubeExplode();
    final client = ytExplode.channels;
    List<Channel> channelList = [];

    try {
      final String cURI = "${baseURL}search";
      final Uri uri = Uri.parse(cURI);
      final Map<String, String> params = {
        'part': 'snippet',
        'type': 'channel',
        'maxResults': '10',
        'q': query,
        'key': youtube_API_key,
      };

      final Uri finalUri = uri.replace(queryParameters: params);

      final http.Response response = await http.get(finalUri);

      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('items')) {
        final List<dynamic> items = data['items'];

        for (var item in items) {
          final Map<String, dynamic> snippet = item['snippet'];
          final dynamic channelId = snippet['channelId'];

          Channel temp = await client.get(channelId);

          channelList.add(temp);
        }
      }
    } catch (error) {
      print('Error: $error');
    }

    ytExplode.close();
    return channelList;
  }

  Future<List<Video>> getAllVideos(String query) async {
    final ytExplode = YoutubeExplode();
    final client = ytExplode.search;
    List<Video> videos = [];

    try {
      videos = await client.search(query);
    } catch (error) {
      print('Error: $error');
    }

    ytExplode.close();
    return videos;
  }

  Future<ChannelData> fetchChannelData(Channel channel) async {
    ChannelData channelData = ChannelData(channel: channel);
    String id = channel.id.toString();

    try {
      final String cURI = "${baseURL}channels";
      final Uri uri = Uri.parse(cURI);
      final Map<String, String> params = {
        'part': 'snippet, contentDetails, statistics',
        'id': id,
        'key': youtube_API_key,
      };

      final Uri finalUri = uri.replace(queryParameters: params);

      final http.Response response = await http.get(finalUri);

      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('items')) {
        final List<dynamic> items = data['items'];

        for (var item in items) {
          Map<String, dynamic> contentDetails = item['contentDetails'];
          Map<String, dynamic> snippet = item['snippet'];
          String channelId = item['id'];
          String PlaylistsId = contentDetails['relatedPlaylists']['uploads'];
          String totalVideoCount = item['statistics']['videoCount'];

          channelData.playlistIds.add(PlaylistsId);
          List<Video> temp = await fetchVideos(PlaylistsId);
          channelData.playlists.addPlaylist(temp);
          channelData.videoCounts.add(temp.length);
          channelData.totalVideoCount = int.parse(totalVideoCount);
        }
      }
    } catch (error) {
      print('Error: $error');
    }

    return channelData;
  }

  Future<List<Video>> fetchVideos(String listId) async {
    YoutubeExplode ytExplode = YoutubeExplode();
    List<Video> playlist = [];

    try {
      Map<String, String> params = {
        'part': 'snippet',
        'playlistId': listId,
        'maxResults': '20',
        'pageToken': _PageToken,
        'key': youtube_API_key,
      };

      final String pURL = "${baseURL}playlistItems";
      final Uri uri = Uri.parse(pURL);

      final Uri finalUri = uri.replace(queryParameters: params);
      final http.Response response = await http.get(finalUri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        _PageToken = data['nextPageToken'] ?? '';

        List<dynamic> vidsJson = data['items'];

        for (var vid in vidsJson) {
          String vidId = vid['snippet']['resourceId']['videoId'];
          Video video = await ytExplode.videos.get(vidId);

          playlist.add(video);
        }
      }
    } catch (error) {
      print('Error: $error');
    }

    ytExplode.close();
    return playlist;
  }

  Future<List<Video>> fetchOtherVids(String query) async {
    List<Video> videos = [];

    videos = await getAllVideos(query);
    videos.removeAt(0);

    return videos;
  }

  Future<List<Playlist>> fetchPlaylist(String query) async {
    YoutubeExplode ytExplode = YoutubeExplode();
    List<Playlist> allPlaylist = [];

    try {
      final String cURI = "${baseURL}search";
      final Uri uri = Uri.parse(cURI);
      final Map<String, String> params = {
        'part': 'snippet',
        'type': 'playlist',
        'q': query,
        'key': youtube_API_key,
      };

      final Uri finalUri = uri.replace(queryParameters: params);

      final http.Response response = await http.get(finalUri);

      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('items')) {
        final List<dynamic> items = data['items'];

        for (var item in items) {
          final Map<String, dynamic> snippet = item['snippet'];
          dynamic id = item['id']['playlistId'];

          Playlist playlist = await ytExplode.playlists.get(id);
          allPlaylist.add(playlist);
        }
      }
    } catch (error) {
      print(error);
    }

    ytExplode.close();

    return allPlaylist;
  }

  Future<Video> getFirstVideo(String query) async {
    YoutubeExplode yte = YoutubeExplode();

    Video first = await yte.playlists.getVideos(query).first;

    return first;
  }

  Future<List<Video>> fetchPlaylistVideos(String query) async {
    YoutubeExplode yte = YoutubeExplode();
    List<Video> videos = [];

    try {
      Stream<Video> playlistVideos = await yte.playlists.getVideos(query);

      print(playlistVideos.length);

      playlistVideos.forEach((video) {
        videos.add(video);
      });

    } catch(error) {
      print(error);
    }

    videos.forEach((element) {
      print(element.title);
    });

    yte.close();
    return videos;
  }
}
