import 'package:spotifyflutterapp/data/models/album.dart';
import 'package:spotifyflutterapp/data/models/artist.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';
import 'package:spotifyflutterapp/data/models/image.dart';

class AlbumInPlaylistPage extends Album {
  int numberOfTracks;
  int numberOfTracksOnAggregating;

  AlbumInPlaylistPage({
    String albumType,
    List<Artist> artists,
    List<String> availableMarkets,
    ExternalUrls externalUrls,
    String href,
    String id,
    List<Image> images,
    String name,
    String releaseDate,
    String releaseDatePrecision,
    int totalTracks,
    String type,
    String uri,
    this.numberOfTracks,
    this.numberOfTracksOnAggregating,
  }) : super(
          albumType,
          artists,
          availableMarkets,
          externalUrls,
          href,
          id,
          images,
          name,
          releaseDate,
          releaseDatePrecision,
          totalTracks,
          type,
          uri,
        );
}
