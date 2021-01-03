// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) {
  return Playlist(
    json['collaborative'] as bool,
    json['description'] as String,
    json['external_urls'] == null
        ? null
        : ExternalUrls.fromJson(json['external_urls'] as Map<String, dynamic>),
    json['href'] as String,
    json['id'] as String,
    (json['images'] as List)
        ?.map(
            (e) => e == null ? null : Image.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['name'] as String,
    json['owner'] == null
        ? null
        : Owner.fromJson(json['owner'] as Map<String, dynamic>),
    json['public'] as bool,
    json['snapshot_id'] as String,
    json['tracks'] == null
        ? null
        : Tracks.fromJson(json['tracks'] as Map<String, dynamic>),
    json['type'] as String,
    json['uri'] as String,
  );
}

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'collaborative': instance.collaborative,
      'description': instance.description,
      'external_urls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'images': instance.images,
      'name': instance.name,
      'owner': instance.owner,
      'public': instance.public,
      'snapshot_id': instance.snapshotId,
      'tracks': instance.tracks,
      'type': instance.type,
      'uri': instance.uri,
    };
