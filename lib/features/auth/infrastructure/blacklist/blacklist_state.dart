import 'package:freezed_annotation/freezed_annotation.dart';

part 'blacklist_state.freezed.dart';

@freezed
class BlacklistState with _$BlacklistState {
  const factory BlacklistState.initial() = _Initial;
  const factory BlacklistState.blackList() = _Blacklist;
  const factory BlacklistState.whiteList() = _Whitelist;
}
