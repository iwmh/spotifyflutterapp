// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tracks _$TracksFromJson(Map<String, dynamic> json) {
  return Tracks(
    json['href'] as String,
    json['total'] as int,
  );
}

Map<String, dynamic> _$TracksToJson(Tracks instance) => <String, dynamic>{
      'href': instance.href,
      'total': instance.total,
    };
