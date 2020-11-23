// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paging<T> _$PagingFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object json) fromJsonT,
) {
  return Paging<T>(
    json['href'] as String,
    (json['items'] as List)?.map(fromJsonT)?.toList(),
    json['limit'] as int,
    json['next'] as String,
    json['offset'] as int,
    json['previous'] as String,
    json['total'] as int,
  );
}

Map<String, dynamic> _$PagingToJson<T>(
  Paging<T> instance,
  Object Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'href': instance.href,
      'items': instance.items?.map(toJsonT)?.toList(),
      'limit': instance.limit,
      'next': instance.next,
      'offset': instance.offset,
      'previous': instance.previous,
      'total': instance.total,
    };
