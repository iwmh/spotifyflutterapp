// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['country'] as String,
    json['display_name'] as String,
    json['email'] as String,
    json['explicit_content'] == null
        ? null
        : ExplicitContent.fromJson(
            json['explicit_content'] as Map<String, dynamic>),
    json['external_urls'] == null
        ? null
        : ExternalUrls.fromJson(json['external_urls'] as Map<String, dynamic>),
    json['followers'] == null
        ? null
        : Followers.fromJson(json['followers'] as Map<String, dynamic>),
    json['href'] as String,
    json['id'] as String,
    json['product'] as String,
    json['type'] as String,
    json['uri'] as String,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'country': instance.country,
      'display_name': instance.displayName,
      'email': instance.email,
      'explicit_content': instance.explicitContent,
      'external_urls': instance.externalUrls,
      'followers': instance.followers,
      'href': instance.href,
      'id': instance.id,
      'product': instance.product,
      'type': instance.type,
      'uri': instance.uri,
    };
