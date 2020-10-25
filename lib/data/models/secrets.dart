import 'package:json_annotation/json_annotation.dart';

part 'secrets.g.dart';

@JsonSerializable()

class Secrets{
  @JsonKey(name: 'client_id')
  final String clientId;

  @JsonKey(name: 'redirect_url')
  final String redirectUrl;

  Secrets(this.clientId, this.redirectUrl);

  factory Secrets.fromJson(Map<String, dynamic> json) =>
      _$SecretsFromJson(json);

  Map<String, dynamic> toJson() => _$SecretsToJson(this);

}