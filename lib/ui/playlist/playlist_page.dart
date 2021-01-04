import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class PlaylistPage extends Page {
  final String playlistId;
  PlaylistPage(this.playlistId);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('playlist ${playlistId} page!'),
            automaticallyImplyLeading: false,
          ),
          body: FutureBuilder(
            future: _getPlaylistTracks(context, playlistId),
            builder: (context, snapshot) {
              Widget child = Container();
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  child = CircularProgressIndicator();
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<PlaylistTrack> playlistTracks = snapshot.data;
                    child = ListView.builder(
                        itemCount: playlistTracks.length,
                        itemBuilder: (context, index) {
                          return Text(playlistTracks[index].track.name);
                        });
                    break;
                  }
              }
              return child;
            },
          ),
        );
      },
    );
  }
}

Future<List<PlaylistTrack>> _getPlaylistTracks(BuildContext context, String playlistId) {
  var apiService = Provider.of<ApiService>(context, listen: false);
  return apiService.getTracksInPlaylist(playlistId);
}
