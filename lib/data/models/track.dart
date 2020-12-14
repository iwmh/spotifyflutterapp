import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/album.dart';
import 'package:spotifyflutterapp/data/models/artist.dart';
import 'package:spotifyflutterapp/data/models/external_ids.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';

part 'track.g.dart';

@JsonSerializable()
class Track {
  @JsonKey(name: 'album')
  final Album album;

  @JsonKey(name: 'artists')
  final List<Artist> artists;

  @JsonKey(name: 'disc_number')
  final int discNumber;

  @JsonKey(name: 'duration_ms')
  final int durationMs;

  @JsonKey(name: 'episode')
  final bool episode;

  @JsonKey(name: 'explicit')
  final bool explicit;

  @JsonKey(name: 'external_ids')
  final ExternalIds externalIds;

  @JsonKey(name: 'external_urls')
  final ExternalUrls externalUrls;

  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'is_local')
  final bool isLocal;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'popularity')
  final int popularity;

  @JsonKey(name: 'track')
  final bool track;

  @JsonKey(name: 'track_number')
  final int trackNumber;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'uri')
  final String uri;

  Track(
      this.album,
      this.artists,
      this.discNumber,
      this.durationMs,
      this.episode,
      this.explicit,
      this.externalIds,
      this.externalUrls,
      this.href,
      this.id,
      this.isLocal,
      this.name,
      this.popularity,
      this.track,
      this.trackNumber,
      this.type,
      this.uri);

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);
}
