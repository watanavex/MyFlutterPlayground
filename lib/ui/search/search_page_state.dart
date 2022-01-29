import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/model/repo_item.dart';

part 'search_page_state.freezed.dart';

typedef RepoItems = List<RepoItem>;

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    required AsyncValue<RepoItems> repoItems,
    required bool isSearchMode,
  }) = _SearchPageState;
}
