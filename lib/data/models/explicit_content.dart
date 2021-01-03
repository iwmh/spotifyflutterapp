import 'package:json_annotation/json_annotation.dart';

part 'explicit_content.g.dart';

@JsonSerializable()
class ExplicitContent {
  @JsonKey(name: 'filter_enabled')
  final bool filterEnabled;

  @JsonKey(name: 'filter_locked')
  final bool filterLocked;

  ExplicitContent(
    this.filterEnabled,
    this.filterLocked,
  );

  factory ExplicitContent.fromJson(Map<String, dynamic> json) => _$ExplicitContentFromJson(json);

  Map<String, dynamic> toJson() => _$ExplicitContentToJson(this);
}
