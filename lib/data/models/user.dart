import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'external_urls')
  final ExternalUrls externalUrls;

  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'uri')
  final String uri;

  User(this.externalUrls, this.href, this.id, this.type, this.uri);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
