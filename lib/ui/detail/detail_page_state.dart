// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:my_flutter_playground/data/repo_detail.dart' as api_response;

part 'detail_page_state.freezed.dart';

@freezed
class DetailPageState with _$DetailPageState {
  const factory DetailPageState({
    required AsyncValue<RepoDetail> detail,
  }) = _DetailPageState;
}

@freezed
class RepoDetail with _$RepoDetail {
  const factory RepoDetail({
    required String owner,
    required String name,
    required String imageUrl,
    required String? language,
    required String? description,
    required int starCount,
    required int forksCount,
    required int watchersCount,
    required int issueCount,
  }) = _RepoDetail;

  factory RepoDetail.from({required api_response.RepoDetail repo}) {
    return RepoDetail(
      owner: repo.owner.login,
      name: repo.name,
      imageUrl: repo.owner.avatarUrl,
      description: repo.description,
      language: repo.language,
      starCount: repo.stargazersCount,
      forksCount: repo.forksCount,
      watchersCount: repo.subscribersCount,
      issueCount: repo.openIssuesCount,
    );
  }
}
