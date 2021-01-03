import 'package:json_annotation/json_annotation.dart';
import 'package:spotifyflutterapp/data/models/external_urls.dart';

part 'owner.g.dart';

@JsonSerializable()
class Owner {
  @JsonKey(name: 'display_name')
  final String displayName;

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

  Owner(this.displayName, this.externalUrls, this.href, this.id, this.type, this.uri);

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
