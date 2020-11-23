import 'package:json_annotation/json_annotation.dart';

part 'tracks.g.dart';

@JsonSerializable()
class Tracks {
  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'total')
  final int total;

  Tracks(this.href, this.total);

  factory Tracks.fromJson(Map<String, dynamic> json) => _$TracksFromJson(json);

  Map<String, dynamic> toJson() => _$TracksToJson(this);
}
