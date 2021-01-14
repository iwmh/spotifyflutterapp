import 'package:flutter/material.dart';
import 'package:spotifyflutterapp/data/models/albumInPlaylistPage.dart';

class AlbumCard extends StatelessWidget {
  final AlbumInPlaylistPage album;
  final ValueChanged<String> onTapped;

  const AlbumCard({
    this.album,
    @required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapped(album.id),
      onLongPress: () => {},
      child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.width * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.network(album.images[0].url),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(children: [
                  Text(
                    album.name,
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.25, fontWeightDelta: 1),
                  ),
                  Text(
                    album.artists.map((e) => e.name).join(', '),
                    style: DefaultTextStyle.of(context).style.apply(color: Colors.grey[700]),
                  ),
                  Text(
                    album.numberOfTracks == null
                        ? '...'
                        : album.numberOfTracks.toString() + ' / ' + album.totalTracks.toString(),
                    style: DefaultTextStyle.of(context).style.apply(
                          color: Colors.grey[700],
                          fontSizeFactor: 0.75,
                        ),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center),
              ),
            ],
          )),
    );
  }
}
