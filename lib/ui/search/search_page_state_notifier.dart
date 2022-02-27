// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/data/search_result.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';

final searchStateNotifierProvider =
    StateNotifierProvider<SearchStateNotifier, SearchPageState>(
        (ref) => SearchStateNotifier(ref.read));

class SearchStateNotifier extends StateNotifier<SearchPageState> {
  SearchStateNotifier(this._reader)
      : super(const SearchPageState(
            asyncState: AsyncState.uninitialized(), isSearchMode: false));

  final Reader _reader;
  late final _searchApi = _reader(searchApiProvider);

  void toggleMode() {
    state = state.copyWith(isSearchMode: !state.isSearchMode);
  }

  void searchRepos(String query) async {
    if (state.asyncState is Searching) {
      return;
    }

    await Future(() {
      state = state.copyWith(
        asyncState: const AsyncState.searching(),
      );
    });

    const page = 1;
    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } catch (e) {
      state = state.copyWith(
        asyncState: const AsyncState.fail(),
      );
      return;
    }
    if (result.items.isEmpty) {
      state = state.copyWith(
        asyncState: const AsyncState.empty(),
      );
      return;
    }

    final repoItems = UiRepoListItem.from(searchResult: result);
    state = state.copyWith(
      asyncState:
          AsyncState.success(repoListItem: repoItems, query: query, page: page),
    );
  }

  void fetchNext() async {
    if (state.asyncState is FetchingNext) {
      return;
    }

    final currentState = state.asyncState.maybeMap(
      success: (value) {
        return value;
      },
      orElse: () {
        AssertionError();
      },
    )!;

    UiRepoListItem repoItems = currentState.repoListItem;
    final String query = currentState.query;
    final int page = currentState.page + 1;

    state = state.copyWith(
      asyncState: AsyncState.fetchingNext(
        repoListItem: repoItems,
        query: query,
        page: page,
      ),
    );

    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } catch (e) {
      state = state.copyWith(
        asyncState: AsyncState.success(
          repoListItem: repoItems.copyWith(hasNext: false),
          query: query,
          page: page,
        ),
      );
      return;
    }

    final newRepoItems = repoItems.add(searchResult: result);

    state = state.copyWith(
      asyncState: AsyncState.success(
        repoListItem: newRepoItems,
        query: query,
        page: page,
      ),
    );
  }

  set debugState(SearchPageState state) {
    assert(() {
      this.state = state;
      return true;
    }(), '');
  }
}
