// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'owner.dart';

part 'repo_summary.freezed.dart';
part 'repo_summary.g.dart';

@freezed
class RepoSummary with _$RepoSummary {
  const factory RepoSummary({
    required String name,
    required Owner owner,
  }) = _RepoSummary;

  factory RepoSummary.fromJson(Map<String, dynamic> json) =>
      _$RepoSummaryFromJson(json);
}
