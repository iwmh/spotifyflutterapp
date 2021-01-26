import 'package:json_annotation/json_annotation.dart';

part 'reorder_items.g.dart';

@JsonSerializable()
class ReorderItems {
  @JsonKey(name: 'range_start')
  final int range_start;

  @JsonKey(name: 'insert_before')
  final int insert_before;

  @JsonKey(name: 'range_length')
  final int range_length;

  @JsonKey(name: 'snapshot_id')
  final String snapshot_id;

  ReorderItems({
    this.range_start,
    this.insert_before,
    this.range_length,
    this.snapshot_id,
  });

  factory ReorderItems.fromJson(Map<String, dynamic> json) => _$ReorderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderItemsToJson(this);
}
