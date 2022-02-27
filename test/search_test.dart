// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/data/search_result.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';
import 'package:my_flutter_playground/ui/search/search_page_state_notifier.dart';
import 'dummy/search_response.dart';
import 'search_test.mocks.dart';

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

late MockSearchApi mockSearchApi;
late ProviderContainer container;
final SearchResult searchResult = () {
  final map = json.decode(dummySearchResponse) as Map<String, dynamic>;
  return SearchResult.fromJson(map);
}();

@GenerateMocks([SearchApi])
void main() {
  setUp(() {
    mockSearchApi = MockSearchApi();
    when(mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.value(searchResult));

    container = ProviderContainer(
      overrides: [searchApiProvider.overrideWithValue(mockSearchApi)],
    );
    addTearDown(container.dispose);
  });

  test("isSearchMode", () {
    final notifier = container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<bool>();
    container.listen(
      searchStateNotifierProvider.select((value) => value.isSearchMode),
      listener,
      fireImmediately: true,
    );

    expect(notifier.debugState.isSearchMode, false);
    notifier.toggleMode();
    expect(notifier.debugState.isSearchMode, true);
  });

  test("searchRepos_success", () async {
    final notifier = container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<AsyncState>();
    container.listen(
      searchStateNotifierProvider.select((value) => value.asyncState),
      listener,
      fireImmediately: true,
    );

    notifier.searchRepos("query");

    await untilCalled(mockSearchApi.search(any, any));
    await Future(() {});

    final repoListItem = UiRepoListItem.from(searchResult: searchResult);
    verifyInOrder([
      listener(any, const AsyncState.uninitialized()),
      listener(any, const AsyncState.searching()),
      listener(
        any,
        AsyncState.success(
          repoListItem: repoListItem,
          query: "query",
          page: 1,
        ),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test("searchRepos_empty", () async {
    when(mockSearchApi.search(any, any)).thenAnswer(
      (realInvocation) => Future.value(const SearchResult(
        totalCount: 0,
        incompleteResults: false,
        items: [],
      )),
    );

    final notifier = container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<AsyncState>();
    container.listen(
      searchStateNotifierProvider.select((value) => value.asyncState),
      listener,
      fireImmediately: true,
    );

    notifier.searchRepos("query");

    await untilCalled(mockSearchApi.search(any, any));
    await Future(() {});

    verifyInOrder([
      listener(any, const AsyncState.uninitialized()),
      listener(any, const AsyncState.searching()),
      listener(any, const AsyncState.empty()),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test("searchRepos error", () async {
    when(mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.error(Error()));

    final notifier = container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<AsyncState>();
    container.listen(
      searchStateNotifierProvider.select((value) => value.asyncState),
      listener,
      fireImmediately: true,
    );

    notifier.searchRepos("query");

    await untilCalled(mockSearchApi.search(any, any));
    await Future(() {});

    verifyInOrder([
      listener(any, const AsyncState.uninitialized()),
      listener(any, const AsyncState.searching()),
      listener(any, const AsyncState.fail()),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test("fetchNext success", () async {
    final notifier = container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<AsyncState>();
    container.listen(
      searchStateNotifierProvider.select((value) => value.asyncState),
      listener,
      fireImmediately: true,
    );

    notifier.debugState = const SearchPageState(
      asyncState: AsyncState.success(
        repoListItem: UiRepoListItem(rawItems: [], hasNext: true),
        query: "query",
        page: 1,
      ),
      isSearchMode: false,
    );

    notifier.fetchNext();

    await untilCalled(mockSearchApi.search(any, any));
    await Future(() {});

    final repoListItem = UiRepoListItem.from(searchResult: searchResult);
    verifyInOrder([
      listener(any, const AsyncState.uninitialized()),
      listener(
        any,
        const AsyncState.success(
          repoListItem: UiRepoListItem(rawItems: [], hasNext: true),
          query: "query",
          page: 1,
        ),
      ),
      listener(
          any,
          const AsyncState.fetchingNext(
            repoListItem: UiRepoListItem(rawItems: [], hasNext: true),
            query: "query",
            page: 2,
          )),
      listener(
        any,
        AsyncState.success(
          repoListItem: repoListItem,
          query: "query",
          page: 2,
        ),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test("fetchNext error", () async {
    when(mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.error(Error()));

    final notifier = container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<AsyncState>();
    container.listen(
      searchStateNotifierProvider.select((value) => value.asyncState),
      listener,
      fireImmediately: true,
    );

    notifier.debugState = const SearchPageState(
      asyncState: AsyncState.success(
        repoListItem: UiRepoListItem(rawItems: [], hasNext: true),
        query: "query",
        page: 1,
      ),
      isSearchMode: false,
    );

    notifier.fetchNext();

    await untilCalled(mockSearchApi.search(any, any));
    await Future(() {});

    verifyInOrder([
      listener(any, const AsyncState.uninitialized()),
      listener(
        any,
        const AsyncState.success(
          repoListItem: UiRepoListItem(rawItems: [], hasNext: true),
          query: "query",
          page: 1,
        ),
      ),
      listener(
          any,
          const AsyncState.fetchingNext(
            repoListItem: UiRepoListItem(rawItems: [], hasNext: true),
            query: "query",
            page: 2,
          )),
      listener(
        any,
        const AsyncState.success(
          repoListItem: UiRepoListItem(rawItems: [], hasNext: false),
          query: "query",
          page: 2,
        ),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });
}
