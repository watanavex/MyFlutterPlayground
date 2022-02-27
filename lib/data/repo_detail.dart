// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'owner.dart';

part 'repo_detail.freezed.dart';
part 'repo_detail.g.dart';

@freezed
class RepoDetail with _$RepoDetail {
  const factory RepoDetail({
    required String name,
    required Owner owner,
    required int stargazersCount,
    required int forksCount,
    required int openIssuesCount,
    required int subscribersCount,
    String? description,
    String? language,
  }) = _RepoDetail;

  factory RepoDetail.fromJson(Map<String, dynamic> json) =>
      _$RepoDetailFromJson(json);
}
