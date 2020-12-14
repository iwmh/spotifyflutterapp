// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistTrack _$PlaylistTrackFromJson(Map<String, dynamic> json) {
  return PlaylistTrack(
    json['added_at'] as String,
    json['added_by'] == null
        ? null
        : User.fromJson(json['added_by'] as Map<String, dynamic>),
    json['is_local'] as bool,
    json['primary_color'] as String,
    json['track'] == null
        ? null
        : Track.fromJson(json['track'] as Map<String, dynamic>),
    json['video_thumbnail'] == null
        ? null
        : VideoThumbnail.fromJson(
            json['video_thumbnail'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlaylistTrackToJson(PlaylistTrack instance) =>
    <String, dynamic>{
      'added_at': instance.addedAt,
      'added_by': instance.addedBy,
      'is_local': instance.isLocal,
      'primary_color': instance.primaryColor,
      'track': instance.track,
      'video_thumbnail': instance.videoThumbnail,
    };
