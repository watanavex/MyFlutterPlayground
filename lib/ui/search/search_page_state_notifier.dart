import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';

final searchStateNotifierProvider =
    StateNotifierProvider<SearchStateNotifier, SearchPageState>(
        (ref) => SearchStateNotifier(ref.read));

class SearchStateNotifier extends StateNotifier<SearchPageState> {
  SearchStateNotifier(this._reader)
      : super(const SearchPageState(repoItems: AsyncValue.data([])));

  final Reader _reader;
  late final _searchApi = _reader(searchApiProvider);

  void searchRepos(String query) async {
    state = const SearchPageState(repoItems: AsyncValue.loading());

    try {
      final result = await _searchApi.search(query);
      state = SearchPageState(repoItems: AsyncValue.data(result.items));
    } catch (e) {
      state = SearchPageState(repoItems: AsyncValue.error(e));
    }
  }
}
