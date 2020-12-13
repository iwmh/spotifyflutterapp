import 'package:flutter/material.dart';

class PlaylistPage extends Page {
  String playlistId;
  PlaylistPage(this.playlistId);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('playlist ${playlistId} page!'),
          ),
          body: Container(),
        );
      },
    );
  }
}
