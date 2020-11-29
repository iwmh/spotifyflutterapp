import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';
import 'package:spotifyflutterapp/data/models/image.dart';
import 'package:spotifyflutterapp/data/models/owner.dart';
import 'package:spotifyflutterapp/data/models/tracks.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist {
  @JsonKey(name: 'collaborative')
  final bool collaborative;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'externalUrls')
  final ExternalUrls externalUrls;

  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'images')
  final List<Image> images;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'owner')
  final Owner owner;

  @JsonKey(name: 'public')
  final bool public;

  @JsonKey(name: 'snapshotId')
  final String snapshotId;

  @JsonKey(name: 'tracks')
  final Tracks tracks;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'uri')
  String uri;

  Playlist(this.collaborative, this.description, this.externalUrls, this.href, this.id, this.images, this.name,
      this.owner, this.public, this.snapshotId, this.tracks, this.type, this.uri);

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
