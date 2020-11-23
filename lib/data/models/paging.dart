import 'package:json_annotation/json_annotation.dart';

part 'paging.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Paging<T> {
  @JsonKey(name: 'href')
  final String href;

  @JsonKey(name: 'items')
  final List<T> items;

  @JsonKey(name: 'limit')
  final int limit;

  @JsonKey(name: 'next')
  final String next;

  @JsonKey(name: 'offset')
  final int offset;

  @JsonKey(name: 'previous')
  final String previous;

  @JsonKey(name: 'total')
  final int total;

  Paging(this.href, this.items, this.limit, this.next, this.offset,
      this.previous, this.total);

  factory Paging.fromJson(
    Map<String, dynamic> json,
    T Function(Object json) fromJsonT,
  ) =>
      _$PagingFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PagingToJson(this, toJsonT);
}
