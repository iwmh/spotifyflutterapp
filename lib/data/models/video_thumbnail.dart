import 'package:json_annotation/json_annotation.dart';

part 'video_thumbnail.g.dart';

@JsonSerializable()
class VideoThumbnail {
  @JsonKey(name: 'url')
  final String addedAt;

  VideoThumbnail(this.addedAt);

  factory VideoThumbnail.fromJson(Map<String, dynamic> json) => _$VideoThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$VideoThumbnailToJson(this);
}
