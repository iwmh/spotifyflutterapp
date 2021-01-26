// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderItems _$ReorderItemsFromJson(Map<String, dynamic> json) {
  return ReorderItems(
    range_start: json['range_start'] as int,
    insert_before: json['insert_before'] as int,
    range_length: json['range_length'] as int,
    snapshot_id: json['snapshot_id'] as String,
  );
}

Map<String, dynamic> _$ReorderItemsToJson(ReorderItems instance) =>
    <String, dynamic>{
      'range_start': instance.range_start,
      'insert_before': instance.insert_before,
      'range_length': instance.range_length,
      'snapshot_id': instance.snapshot_id,
    };
