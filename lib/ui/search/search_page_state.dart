// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:my_flutter_playground/data/search_result.dart';

part 'search_page_state.freezed.dart';

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    required AsyncState asyncState,
    required bool isSearchMode,
  }) = _SearchPageState;
}

@freezed
class UiRepoListItem with _$UiRepoListItem {
  const UiRepoListItem._();
  const factory UiRepoListItem({
    required List<Repo> rawItems,
    required bool hasNext,
  }) = _UiRepoListItem;

  factory UiRepoListItem.from({required SearchResult searchResult}) {
    List<Repo> repos = searchResult.items
        .map((item) => Repo(
            owner: item.owner.login,
            name: item.name,
            imageUrl: item.owner.avatarUrl))
        .toList();

    final hasNext = searchResult.items.length < searchResult.totalCount;
    return UiRepoListItem(rawItems: repos, hasNext: hasNext);
  }

  UiRepoListItem add({required SearchResult searchResult}) {
    var repos = searchResult.items
        .map((item) => Repo(
            owner: item.owner.login,
            name: item.name,
            imageUrl: item.owner.avatarUrl))
        .toList();

    final hasNext = searchResult.items.length < searchResult.totalCount;
    return UiRepoListItem(rawItems: rawItems + repos, hasNext: hasNext);
  }

  // List<ListItem> items() =>
  //     hasNext ? [...rawItems, const ListItem.indicator()] : rawItems;

  // UiRepoListItem update({required bool hasNext}) {
  //   return UiRepoListItem(rawItems: rawItems, hasNext: hasNext);
  // }

  List<ListItem> get items =>
      hasNext ? [...rawItems, const ListItem.indicator()] : rawItems;

  // @override
  // List<Object?> get props => [items, _hasNext];
}

@freezed
class AsyncState with _$AsyncState {
  const factory AsyncState.uninitialized() = Uninitialized;
  const factory AsyncState.searching() = Searching;
  const factory AsyncState.success({
    required UiRepoListItem repoListItem,
    required String query,
    required int page,
  }) = Success;

  const factory AsyncState.fetchingNext({
    required UiRepoListItem repoListItem,
    required String query,
    required int page,
  }) = FetchingNext;
  const factory AsyncState.fail() = Fail;
  const factory AsyncState.empty() = Empty;
}

@freezed
abstract class ListItem with _$ListItem {
  const factory ListItem.indicator() = Indicator;
  const factory ListItem.repo({
    required String owner,
    required String name,
    required String imageUrl,
  }) = Repo;
}
