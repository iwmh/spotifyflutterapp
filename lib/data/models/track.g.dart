// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) {
  return Track(
    json['album'] == null
        ? null
        : Album.fromJson(json['album'] as Map<String, dynamic>),
    (json['artists'] as List)
        ?.map((e) =>
            e == null ? null : Artist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['disc_number'] as int,
    json['duration_ms'] as int,
    json['episode'] as bool,
    json['explicit'] as bool,
    json['external_ids'] == null
        ? null
        : ExternalIds.fromJson(json['external_ids'] as Map<String, dynamic>),
    json['external_urls'] == null
        ? null
        : ExternalUrls.fromJson(json['external_urls'] as Map<String, dynamic>),
    json['href'] as String,
    json['id'] as String,
    json['is_local'] as bool,
    json['name'] as String,
    json['popularity'] as int,
    json['track'] as bool,
    json['track_number'] as int,
    json['type'] as String,
    json['uri'] as String,
  );
}

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'album': instance.album,
      'artists': instance.artists,
      'disc_number': instance.discNumber,
      'duration_ms': instance.durationMs,
      'episode': instance.episode,
      'explicit': instance.explicit,
      'external_ids': instance.externalIds,
      'external_urls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'is_local': instance.isLocal,
      'name': instance.name,
      'popularity': instance.popularity,
      'track': instance.track,
      'track_number': instance.trackNumber,
      'type': instance.type,
      'uri': instance.uri,
    };
