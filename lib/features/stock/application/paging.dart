import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging.freezed.dart';

part 'paging.g.dart';

@freezed
class Paging with _$Paging {
  const factory Paging({
    @JsonKey(name: 'page_no') required String pageNo,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'total_doc') required int totalDoc,
    @JsonKey(name: 'total_page') required int totalPage,
  }) = _Paging;

  factory Paging.fromJson(Map<String, Object?> json) => _$PagingFromJson(json);

  factory Paging.initial() =>
      const Paging(pageNo: '1', pageSize: 1, totalDoc: 0, totalPage: 1);
}
