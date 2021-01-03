// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explicit_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExplicitContent _$ExplicitContentFromJson(Map<String, dynamic> json) {
  return ExplicitContent(
    json['filter_enabled'] as bool,
    json['filter_locked'] as bool,
  );
}

Map<String, dynamic> _$ExplicitContentToJson(ExplicitContent instance) =>
    <String, dynamic>{
      'filter_enabled': instance.filterEnabled,
      'filter_locked': instance.filterLocked,
    };
