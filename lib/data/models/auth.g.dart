// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(json['access_token'] as String, json['token_type'] as String, json['scope'] as String,
      json['expires_in'] as int, json['refresh_token'] as String);
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'scope': instance.scope,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken
    };
