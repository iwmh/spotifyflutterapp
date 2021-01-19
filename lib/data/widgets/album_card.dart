import 'package:flutter/material.dart';
import 'package:spotifyflutterapp/data/models/albumInPlaylistPage.dart';

class AlbumCard extends StatelessWidget {
  final ValueKey key;
  final AlbumInPlaylistPage album;
  final ValueChanged<String> onFunction;

  const AlbumCard({
    this.key,
    this.album,
    @required this.onFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onFunction(album.id),
      onLongPress: () => {},
      child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.network(album.images[1].url),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    Text(
                      album.name,
                      style: DefaultTextStyle.of(context).style.apply(
                            fontSizeFactor: 1.25,
                            fontWeightDelta: 1,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(
                      album.artists.map((e) => e.name).join(', '),
                      style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[400],
                          ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(
                      album.releaseDate,
                      style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[400],
                            fontSizeFactor: 0.75,
                          ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(
                      album.numberOfTracks == null
                          ? '...'
                          : album.numberOfTracks.toString() + ' / ' + album.totalTracks.toString(),
                      style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[400],
                            fontSizeFactor: 0.75,
                          ),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          )),
    );
  }
}
