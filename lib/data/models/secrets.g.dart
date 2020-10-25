// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secrets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secrets _$SecretsFromJson(Map<String, dynamic> json) {
  return Secrets(
    json['client_id'] as String,
    json['redirect_url'] as String,
  );
}

Map<String, dynamic> _$SecretsToJson(Secrets instance) => <String, dynamic>{
      'client_id': instance.clientId,
      'redirect_url': instance.redirectUrl,
    };
