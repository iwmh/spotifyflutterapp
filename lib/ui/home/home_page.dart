import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/widgets/playlist_card.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class HomePage extends Page {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('home page!'),
  //     ),
  //     body: FutureBuilder(
  //       future: _getPlaylist(context),
  //       builder: (context, snapshot) {
  //         Widget child = Container();
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.none:
  //           case ConnectionState.active:
  //           case ConnectionState.waiting:
  //             child = CircularProgressIndicator();
  //             break;
  //           case ConnectionState.done:
  //             if (snapshot.hasData) {
  //               List<Playlist> playlists = snapshot.data;
  //               child = ListView.builder(
  //                   itemCount: playlists.length,
  //                   itemBuilder: (context, index) {
  //                     return PlaylistCard(
  //                       id: playlists[index].id,
  //                       imageUrl: playlists[index].images[0].url,
  //                       name: playlists[index].name,
  //                       owner: playlists[index].owner.id,
  //                     );
  //                   });
  //               break;
  //             }
  //         }
  //         return child;
  //       },
  //     ),
  //   );
  // }

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('home page!'),
          ),
          body: FutureBuilder(
            future: _getPlaylist(context),
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
                    List<Playlist> playlists = snapshot.data;
                    child = ListView.builder(
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return PlaylistCard(
                            id: playlists[index].id,
                            imageUrl: playlists[index].images[0].url,
                            name: playlists[index].name,
                            owner: playlists[index].owner.id,
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
