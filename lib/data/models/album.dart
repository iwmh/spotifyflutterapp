import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';
import 'package:spotifyflutterapp/data/models/image.dart';
import 'package:spotifyflutterapp/data/models/artist.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
  @JsonKey(name: 'album_type')
  final String albumType;

  @JsonKey(name: 'artists')
  final List<Artist> artists;

  @JsonKey(name: 'available_markets')
  final List<String> availableMarkets;

  @JsonKey(name: 'external_urls')
  final ExternalUrls externalUrls;

  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'images')
  final List<Image> images;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'release_date')
  final String releaseDate;

  @JsonKey(name: 'release_date_precision')
  final String releaseDatePrecision;

  @JsonKey(name: 'total_tracks')
  final int totalTracks;

  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'uri')
  final String uri;

  Album(this.albumType, this.artists, this.availableMarkets, this.externalUrls, this.href, this.id, this.images,
      this.name, this.releaseDate, this.releaseDatePrecision, this.totalTracks, this.type, this.uri);

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
