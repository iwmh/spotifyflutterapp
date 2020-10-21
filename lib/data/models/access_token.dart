import 'package:json_annotation/json_annotation.dart';

part 'access_token.g.dart';

@JsonSerializable()

class AccessToken{
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'scope')
  final String scope;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  AccessToken(this.accessToken, this.tokenType, this.scope, this.expiresIn, this.refreshToken);

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenToJson(this);

}