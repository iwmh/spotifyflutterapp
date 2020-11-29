// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Owner _$OwnerFromJson(Map<String, dynamic> json) {
  return Owner(
    json['displayName'] as String,
    json['externalUrls'] == null ? null : ExternalUrls.fromJson(json['externalUrls'] as Map<String, dynamic>),
    json['href'] as String,
    json['id'] as String,
    json['type'] as String,
    json['uri'] as String,
  );
}

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'externalUrls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'type': instance.type,
      'uri': instance.uri,
    };
