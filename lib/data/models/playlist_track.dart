import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/track.dart';
import 'package:spotifyflutterapp/data/models/user.dart';
import 'package:spotifyflutterapp/data/models/video_thumbnail.dart';

part 'playlist_track.g.dart';

@JsonSerializable()
class PlaylistTrack {
  @JsonKey(name: 'added_at')
  final String addedAt;

  @JsonKey(name: 'added_by')
  final User addedBy;

  @JsonKey(name: 'is_local')
  final bool isLocal;

  @JsonKey(name: 'primary_color')
  final String primaryColor;

  @JsonKey(name: 'track')
  final Track track;

  @JsonKey(name: 'video_thumbnail')
  final VideoThumbnail videoThumbnail;

  PlaylistTrack(this.addedAt, this.addedBy, this.isLocal, this.primaryColor, this.track, this.videoThumbnail);

  factory PlaylistTrack.fromJson(Map<String, dynamic> json) => _$PlaylistTrackFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistTrackToJson(this);
}
