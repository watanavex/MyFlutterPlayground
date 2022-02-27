// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:my_flutter_playground/api/repository_api.dart';
import 'package:my_flutter_playground/ui/detail/detail_page_state.dart';

final detailPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<DetailPageStateNotifier, DetailPageState>(
        (ref) => DetailPageStateNotifier(ref.read));

class DetailPageStateNotifier extends StateNotifier<DetailPageState> {
  DetailPageStateNotifier(this._reader)
      : super(const DetailPageState(detail: AsyncValue.loading()));

  final Reader _reader;

  void fetch({required String owner, required String repo}) async {
    await Future(() {
      state = state.copyWith(
        detail: const AsyncValue.loading(),
      );
    });

    final repositoryApi = _reader(repositoryApiProvider);

    try {
      final repoItem = await repositoryApi.fetch(owner, repo);
      final detail = RepoDetail.from(repo: repoItem);
      state = state.copyWith(detail: AsyncValue.data(detail));
    } catch (e) {
      state = state.copyWith(
        detail: AsyncValue.error(e),
      );
    }
  }
}
