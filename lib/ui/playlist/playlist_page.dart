import 'package:flutter/material.dart';
import 'package:spotifyflutterapp/ui/playlist/playlist_screen.dart';

class PlaylistPage extends Page {
  final String playlistId;
  const PlaylistPage(this.playlistId);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return PlaylistScreen(playlistId);
      },
    );
  }
}

// Future<List<PlaylistTrack>> _getPlaylistTracks(BuildContext context, String playlistId) {
//   var apiService = Provider.of<ApiService>(context, listen: false);
//   return apiService.getTracksInPlaylist(playlistId);
// }
