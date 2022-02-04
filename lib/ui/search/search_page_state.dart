import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'search_page_state.freezed.dart';

typedef Repos = List<Repo>;

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    required AsyncValue<Repos> repos,
    required bool isSearchMode,
  }) = _SearchPageState;
}

@freezed
class Repo with _$Repo {
  const factory Repo({
    required String owner,
    required String name,
    required String imageUrl,
  }) = _Repo;
}
