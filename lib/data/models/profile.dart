import 'package:json_annotation/json_annotation.dart';

import 'explicit_content.dart';
import 'external_urls.dart';
import 'followers.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'display_name')
  final String displayName;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'explicit_content')
  final ExplicitContent explicitContent;

  @JsonKey(name: 'external_urls')
  final ExternalUrls externalUrls;

  @JsonKey(name: 'followers')
  final Followers followers;

  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'product')
  final String product;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'uri')
  final String uri;

  Profile(
    this.country,
    this.displayName,
    this.email,
    this.explicitContent,
    this.externalUrls,
    this.followers,
    this.href,
    this.id,
    this.product,
    this.type,
    this.uri,
  );

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
