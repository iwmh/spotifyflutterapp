import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  @JsonKey(name: 'height')
  final int height;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'width')
  final int width;

  Image(this.height, this.url, this.width);

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
