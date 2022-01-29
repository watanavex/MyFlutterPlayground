import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueExtention<T> on AsyncValue<T> {
  Widget on({
    required Widget Function(T data) success,
    Widget Function(Object error) error = buidErrorWidget,
    Widget Function() loading = buildLoadingWidget,
  }) {
    return when(
      data: success,
      error: (e, stackTrace) => error(e),
      loading: () => loading(),
    );
  }
}

Widget buildLoadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget buidErrorWidget(Object error) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.error,
          size: 80,
          color: Colors.red,
        ),
        Text(
          "エラーが発生しました。こりゃ大変だぁ。",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
