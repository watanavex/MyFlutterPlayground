import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/data/search_result.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';
import 'package:tuple/tuple.dart';

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

    List<Repo> repos = result.items
        .map((item) => Repo(
            owner: item.owner.login,
            name: item.name,
            imageUrl: item.owner.avatarUrl))
        .toList();

    final hasNext = result.items.length < result.totalCount;
    final repoItems = UiRepoListItem(repos, hasNext);
    state = state.copyWith(
      asyncState:
          AsyncState.success(repoListItem: repoItems, query: query, page: page),
    );
  }

  void fetchNext() async {
    if (state.asyncState is FetchingNext) {
      return;
    }

    final tuple = state.asyncState.maybeMap(
      success: (value) {
        return Tuple3(value.repoListItem, value.query, value.page + 1);
      },
      orElse: () {
        AssertionError();
      },
    );
    if (tuple == null) {
      return;
    }

    UiRepoListItem repoItems = tuple.item1;
    final String query = tuple.item2;
    final int page = tuple.item3;

    state = state.copyWith(
      asyncState: AsyncState.fetchingNext(
          repoListItem: repoItems, query: query, page: page),
    );

    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } catch (e) {
      state = state.copyWith(
        asyncState: AsyncState.success(
            repoListItem: repoItems.update(hasNext: false),
            query: query,
            page: page),
      );
      return;
    }

    var repos = result.items
        .map((item) => Repo(
            owner: item.owner.login,
            name: item.name,
            imageUrl: item.owner.avatarUrl))
        .toList();

    final hasNext = result.items.length < result.totalCount;
    final newRepoItems = repoItems.add(rawItems: repos, hasNext: hasNext);

    state = state.copyWith(
      asyncState: AsyncState.success(
        repoListItem: newRepoItems,
        query: query,
        page: page,
      ),
    );
  }
}
