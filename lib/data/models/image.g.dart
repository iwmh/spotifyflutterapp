// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['height'] as int,
    json['url'] as String,
    json['width'] as int,
  );
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };
