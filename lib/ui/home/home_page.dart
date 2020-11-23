import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home page!'),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            color: Colors.grey,
            child: Text(
              "get playlists",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            padding: EdgeInsets.all(20),
          ),
          onTap: () {
            _getPlaylist(context);
          },
        ),
      ),
    );
  }
}

Future<List<Playlist>> _getPlaylist(BuildContext context) async {
  var apiService = Provider.of<ApiService>(context, listen: false);
  apiService.getPlaylists();
}
