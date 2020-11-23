import 'package:json_annotation/json_annotation.dart';

part 'external_urls.g.dart';

@JsonSerializable()
class ExternalUrls {
  @JsonKey(name: 'spotify')
  final String spotidy;

  ExternalUrls(this.spotidy);

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalUrlsToJson(this);
}
