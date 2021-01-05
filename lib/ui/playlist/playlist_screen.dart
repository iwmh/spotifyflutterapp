import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistId;
  const PlaylistScreen(this.playlistId);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Future<List<PlaylistTrack>> future;
  @override
  void initState() {
    var apiService = Provider.of<ApiService>(context, listen: false);
    future = apiService.getTracksInPlaylist(widget.playlistId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('playlist $widget.playlistId page!'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          Widget child = Container();
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              child = const CircularProgressIndicator();
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
  }
}
