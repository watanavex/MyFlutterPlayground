import 'package:freezed_annotation/freezed_annotation.dart';
import 'owner.dart';

part 'repo_item.freezed.dart';
part 'repo_item.g.dart';

@freezed
class RepoItem with _$RepoItem {
  const factory RepoItem({
    required String name,
    required Owner owner,
    required int stargazersCount,
    required int forksCount,
    required int openIssuesCount,
    required String description,
    String? language,
  }) = _RepoItem;

  factory RepoItem.fromJson(Map<String, dynamic> json) =>
      _$RepoItemFromJson(json);
}
