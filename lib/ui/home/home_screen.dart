import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/widgets/playlist_card.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> onTapped;
  const HomeScreen(this.onTapped);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Playlist>> future;

  @override
  void initState() {
    var apiService = Provider.of<ApiService>(context, listen: false);
    future = apiService.getPlaylists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your playlists'),
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
              child = const Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<Playlist> unfilteredPlaylists = snapshot.data;
                // the playlist owner should be yourself.
                final service = Provider.of<ApiService>(context, listen: false);
                final playlists =
                    unfilteredPlaylists.where((element) => element.owner.displayName == service.displayName).toList();
                child = ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return PlaylistCard(
                        id: playlists[index].id,
                        imageUrl: playlists[index].images[0].url,
                        name: playlists[index].name,
                        owner: playlists[index].owner.id,
                        onTapped: widget.onTapped,
                      );
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
