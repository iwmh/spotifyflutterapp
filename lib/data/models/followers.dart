import 'package:json_annotation/json_annotation.dart';

part 'followers.g.dart';

@JsonSerializable()
class Followers {
  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'total')
  final int total;

  Followers(
    this.href,
    this.total,
  );

  factory Followers.fromJson(Map<String, dynamic> json) => _$FollowersFromJson(json);

  Map<String, dynamic> toJson() => _$FollowersToJson(this);
}
