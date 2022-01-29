import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';

final searchStateNotifierProvider =
    StateNotifierProvider<SearchStateNotifier, SearchPageState>(
        (ref) => SearchStateNotifier(ref.read));

class SearchStateNotifier extends StateNotifier<SearchPageState> {
  SearchStateNotifier(this._reader)
      : super(const SearchPageState(repoItems: []));

  final Reader _reader;
  late final _searchApi = _reader(searchApiProvider);

  void searchRepos(String query) async {
    final result = await _searchApi.search(query);
    state = state.copyWith(repoItems: result.items);
  }
}
