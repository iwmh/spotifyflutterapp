import 'package:json_annotation/json_annotation.dart';

part 'snapshot_id.g.dart';

@JsonSerializable()
class SnapshotId {
  @JsonKey(name: 'snapshot_id')
  final String snapshotId;

  SnapshotId(this.snapshotId);

  factory SnapshotId.fromJson(Map<String, dynamic> json) => _$SnapshotIdFromJson(json);

  Map<String, dynamic> toJson() => _$SnapshotIdToJson(this);
}
