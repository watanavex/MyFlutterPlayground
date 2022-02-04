import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';

final searchStateNotifierProvider =
    StateNotifierProvider<SearchStateNotifier, SearchPageState>(
        (ref) => SearchStateNotifier(ref.read));

class SearchStateNotifier extends StateNotifier<SearchPageState> {
  SearchStateNotifier(this._reader)
      : super(const SearchPageState(
            repos: AsyncValue.data([]), isSearchMode: false));

  final Reader _reader;
  late final _searchApi = _reader(searchApiProvider);

  void toggleMode() {
    state = state.copyWith(isSearchMode: !state.isSearchMode);
  }

  void searchRepos(String query) async {
    if (state.repos is AsyncLoading) {
      return;
    }
    state = state.copyWith(
      repos: const AsyncValue.loading(),
    );

    try {
      final result = await _searchApi.search(query);
      final repos = result.items
          .map((item) => Repo(
              owner: item.owner.login,
              name: item.name,
              imageUrl: item.owner.avatarUrl))
          .toList();
      state = state.copyWith(
        repos: AsyncValue.data(repos),
      );
    } catch (e) {
      state = state.copyWith(
        repos: AsyncValue.error(e),
      );
    }
  }
}
