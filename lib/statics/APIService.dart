import 'dart:convert';
import 'dart:developer';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/classes/forChannels/channelData.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player/classes/others/searchData.dart';

import '../classes/others/ovlData.dart';
import 'keys.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String baseURL = "https://www.googleapis.com/youtube/v3/";
  final String _PageToken = '';
  final ytExplode = YoutubeExplode();

  void dispose() {
    ytExplode.close();
  }

  Future<List<Video>> getSearchedVideos(SearchData data) async {
    List<Video> temp = [];

    try {
      if (data.videoList.isEmpty) {
        data.videoSearchList = await ytExplode.search
            .search(data.searchQuery, filter: TypeFilters.video);
      } else {
        data.videoSearchList = await data.videoSearchList?.nextPage();
      }

      for (var element in data.videoSearchList!) {
        temp.add(element);
      }
      if (temp.isEmpty) {
        data.reachedVideoLimit;
      }
    } catch (error) {
      log('${DateTime.now()}, at getSearchedVideos, error:$error');
    }

    return temp;
  }

  Future<List<Channel>> getSearchedChannels(SearchData data) async {
    List<Channel> temp = [];

    try {
      if (data.channelList.isEmpty) {
        data.channelSearchList = await ytExplode.search
            .searchContent(data.searchQuery, filter: TypeFilters.channel);
      } else {
        data.channelSearchList = await data.channelSearchList?.nextPage();
      }

      for (var element in data.channelSearchList!) {
        temp.add(await ytExplode.channels.get(element.id));
      }
      if (temp.isEmpty) {
        data.channelLimitReached;
      }
    } catch (error) {
      log('${DateTime.now()}, at getSearchedChannels, error:$error');
    }

    return temp;
  }

  Future<List<Playlist>> getSearchedPlaylists(SearchData data) async {
    List<Playlist> temp = [];

    try {
      if (data.playlistList.isEmpty) {
        data.playlistSearchList = await ytExplode.search
            .searchContent(data.searchQuery, filter: TypeFilters.playlist);
      } else {
        data.playlistSearchList = await data.playlistSearchList?.nextPage();
      }

      for (var element in data.playlistSearchList!) {
        temp.add(await ytExplode.playlists.get(element.id));
      }
      if (temp.isEmpty) {
        data.reachedPlaylistLimit;
      }
    } catch (error) {
      log('${DateTime.now()}, at getSearchedPlaylists, error:$error');
    }

    return temp;
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
          String description = snippet['description'];
          String PlaylistsId = contentDetails['relatedPlaylists']['uploads'];
          String totalVideoCount = item['statistics']['videoCount'];

          channelData.playlistIds.add(PlaylistsId);
          // List<Video> temp = await fetchVideos(PlaylistsId);
          // channelData.playlists.addPlaylist(temp);
          // channelData.videoCounts.add(temp.length);
          channelData.totalVideoCount = int.parse(totalVideoCount);
          channelData.description = description;
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

  Future<void> fetchChannelUploads(ChannelData data) async {
    List<Video> temp = [];
    try {
      await for (var video in ytExplode.channels
          .getUploads(data.channel?.id)
          .skip(data.uploads.length)
          .take(5)) {
        temp.add(video);
      }
    } catch (error) {
      log('${DateTime.now()}, at fetchChannelUploads, error:$error');
    }

    for (var vid in temp) {
      data.uploads.add(await getCompleteData(vid));
    }
  }

  Future<void> getVideos(String query, OVLData ovlData) async {
    final client = ytExplode.search;

    try {
      if (ovlData.videos.isEmpty) {
        ovlData.vsl = await client.search(query, filter: SortFilters.relevance);
        for (var video in ovlData.vsl!) {
          ovlData.videos.add(video);
        }
        ovlData.videos.removeAt(0);
      } else {
        ovlData.vsl = await ovlData.vsl?.nextPage();
        for (var video in ovlData.vsl!) {
          ovlData.videos.add(video);
        }
      }
    } catch (error) {
      log('${DateTime.now()}, at getVideos, Error: $error');
    }
  }

  Future<void> fetchOtherVids(String query, OVLData ovlData) async {
    try {
      await getVideos(query, ovlData);
    } catch (error) {
      log('${DateTime.now()}, at fetchOtherVids, Error: $error');
    }
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
