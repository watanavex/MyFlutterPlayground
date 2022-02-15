import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_page_state.freezed.dart';

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    required AsyncState asyncState,
    required bool isSearchMode,
  }) = _SearchPageState;
}

class UiRepoListItem {
  List<Repo> _rawItems = [];
  bool _hasNext = false;

  UiRepoListItem(List<Repo> rawItems, bool hasNext) {
    _rawItems = rawItems;
    _hasNext = hasNext;
  }

  UiRepoListItem add({required List<Repo> rawItems, required bool hasNext}) {
    return UiRepoListItem(_rawItems + rawItems, hasNext);
  }

  UiRepoListItem update({required bool hasNext}) {
    return UiRepoListItem(_rawItems, hasNext);
  }

  List<Repo> raw() {
    return _rawItems;
  }

  late final List<ListItem> items =
      _hasNext ? [..._rawItems, const ListItem.indicator()] : _rawItems;
}

@freezed
abstract class AsyncState with _$AsyncState {
  const factory AsyncState.uninitialized() = Uninitialized;
  const factory AsyncState.searching() = Searching;
  const factory AsyncState.success(
      {required UiRepoListItem repoListItem,
      required String query,
      required int page}) = Success;

  const factory AsyncState.fetchingNext(
      {required UiRepoListItem repoListItem,
      required String query,
      required int page}) = FetchingNext;
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
