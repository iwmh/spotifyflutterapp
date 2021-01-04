import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/widgets/playlist_card.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class HomePage extends Page {
  final ValueChanged<String> onTapped;
  const HomePage({@required this.onTapped});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('home page!'),
            automaticallyImplyLeading: false,
          ),
          body: FutureBuilder(
            future: _getPlaylist(context),
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
                    List<Playlist> unfilteredPlaylists = snapshot.data;
                    // the playlist owner should be yourself.
                    final service = Provider.of<ApiService>(context, listen: false);
                    final playlists = unfilteredPlaylists
                        .where((element) => element.owner.displayName == service.displayName)
                        .toList();
                    child = ListView.builder(
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return PlaylistCard(
                            id: playlists[index].id,
                            imageUrl: playlists[index].images[0].url,
                            name: playlists[index].name,
                            owner: playlists[index].owner.id,
                            onTapped: onTapped,
                          );
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

Future<List<Playlist>> _getPlaylist(BuildContext context) {
  var apiService = Provider.of<ApiService>(context, listen: false);
  return apiService.getPlaylists();
}
