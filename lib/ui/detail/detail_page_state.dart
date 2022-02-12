import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/data/async.dart';

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
}
