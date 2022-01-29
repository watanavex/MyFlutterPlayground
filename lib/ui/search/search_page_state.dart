import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_flutter_playground/model/repo_item.dart';

part 'search_page_state.freezed.dart';

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    required List<RepoItem> repoItems,
  }) = _SearchPageState;
}
