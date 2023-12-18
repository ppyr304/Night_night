import 'dart:convert';
import 'dart:developer';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forChannels/channelData.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player/classes/others/searchData.dart';
import 'package:youtube_player/statics/dupTracker.dart';

import 'keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String baseURL = "https://www.googleapis.com/youtube/v3/";
  String _PageToken = '';
  final ytExplode = YoutubeExplode();

  void resetTracker() {
    DupTracker.instance.resetAll();
  }

  void dispose () {
    ytExplode.close();
  }

  Future<List<Video>> getSearchedVideos(SearchData data) async {
    List<Video> temp = [];

    try {
      if (data.videoSearchList == null || data.videoSearchList!.isEmpty) {
        data.videoSearchList = await ytExplode.search
            .search(data.searchQuery, filter: TypeFilters.video);
      } else {
        await data.videoSearchList?.nextPage();
      }

      for (var element in data.videoSearchList!) {
        temp.add(element);
      }
    } catch (error) {
      log('${DateTime.now()}, at getSearchedVideos, error:$error');
    } finally {
    }

    return temp;
  }

  Future<List<Channel>> getSearchedChannels(SearchData data) async {
    List<Channel> temp = [];

    try {
      if (data.channelSearchList == null || data.channelSearchList!.isEmpty) {
        data.channelSearchList = await ytExplode.search
            .searchContent(data.searchQuery, filter: TypeFilters.channel);
      } else {
        await data.channelSearchList?.nextPage();
      }

      for (var element in data.channelSearchList!) {
        temp.add(await ytExplode.channels.get(element.id));
      }
    } catch (error) {
      log('${DateTime.now()}, at getSearchedChannels, error:$error');
    }

    return temp;
  }

  Future<List<Playlist>> getSearchedPlaylists(SearchData data) async {
    List<Playlist> temp = [];

    try {
      if (data.playlistSearchList == null || data.playlistSearchList!.isEmpty) {
        data.playlistSearchList = await ytExplode.search
            .searchContent(data.searchQuery, filter: TypeFilters.playlist);
      } else {
        await data.playlistSearchList?.nextPage();
      }

      for (var element in data.playlistSearchList!) {
        temp.add(await ytExplode.playlists.get(element.id));
      }
    } catch (error) {
      log('${DateTime.now()}, at getSearchedPlaylists, error:$error');
    }

    return temp;
  }

  Future<List<Video>> getAllVideos(String query) async {
    final client = ytExplode.search;
    List<Video> videos = [];

    try {
      videos = await client.search(query, filter: SortFilters.relevance);

      for (var element in videos) {
        if (DupTracker.instance.fetchedVideoIds.contains(element.id)) {
          videos.remove(element);
        } else {
          DupTracker.instance.fetchedVideoIds.add(element.id);
        }
      }
    } catch (error) {
      log('${DateTime.now()} Error: $error');
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
          // List<Video> temp = await fetchVideos(PlaylistsId);
          // channelData.playlists.addPlaylist(temp);
          // channelData.videoCounts.add(temp.length);
          channelData.totalVideoCount = int.parse(totalVideoCount);
        }
      }
    } catch (error) {
      log('${DateTime.now()} Error: $error');
    }

    return channelData;
  }

  Future<Video> getCompleteData(Video video) async {
    late Video actual;

    try {
      actual = await ytExplode.videos.get(video.id);
    } catch (error) {
      log('${DateTime.now()}, at getCompleteData, error:$error');
    }

    return actual;
  }

  Future<List<Video>> fetchChannelUploads(Channel channel, int tracker) async {
    List<Video> temp = [];
    List<Video> uploads = [];

    try {
      await for (var video in ytExplode.channels.getUploads(channel.id)) {
        temp.add(video);
      }

      for (int x = tracker; x < (tracker + 10) && x < temp.length; x++) {
        uploads.add(await getCompleteData(temp[x]));
      }
    } catch (error) {
      log('${DateTime.now()}, at fetchChannelUploads, error:$error');
    }

    return uploads;
  }

  Future<List<Video>> fetchVideos(String listId) async {
    List<Video> playlist = [];

    try {
      Map<String, String> params = {
        'part': 'snippet',
        'playlistId': listId,
        'maxResults': '10',
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
      log('${DateTime.now()} Error: $error');
    }

    return playlist;
  }

  Future<List<Video>> fetchOtherVids(String query) async {
    List<Video> videos = [];

    videos = await getAllVideos(query);
    videos.removeAt(0);

    return videos;
  }

  Future<List<Playlist>> fetchPlaylist(String query) async {
    List<Playlist> allPlaylist = [];

    try {
      final String cURI = "${baseURL}search";
      final Uri uri = Uri.parse(cURI);
      final Map<String, String> params = {
        'part': 'snippet',
        'type': 'playlist',
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
          dynamic id = item['id']['playlistId'];

          Playlist playlist = await ytExplode.playlists.get(id);
          allPlaylist.add(playlist);
        }
      }

      for (var element in allPlaylist) {
        if (DupTracker.instance.fetchedPlaylistIds.contains(element.id)) {
          allPlaylist.remove(element);
        } else {
          DupTracker.instance.fetchedPlaylistIds.add(element.id);
        }
      }
    } catch (error) {
      log('${DateTime.now()}, at fetchPlaylist, Error: $error');
    }

    return allPlaylist;
  }

  Future<Video> getFirstVideo(String query) async {

    Video first = await ytExplode.playlists.getVideos(query).first;

    return first;
  }

  Future<List<Video>> fetchPlaylistVideos(String playlistID) async {
    List<Video> videos = [];

    try {
      await ytExplode.playlists.getVideos(playlistID).forEach((element) {
        videos.add(element);
      });
    } catch (error) {
      log('${DateTime.now()}, at fetchPlaylistVideos, Error: $error');
    }
    return videos;
  }
}
