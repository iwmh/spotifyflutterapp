import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';

part 'artist.g.dart';

@JsonSerializable()
class Artist {
  @JsonKey(name: 'external_urls')
  final ExternalUrls externalUrls;

  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'uri')
  final String uri;

  Artist(this.externalUrls, this.href, this.id, this.name, this.type, this.uri);

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
