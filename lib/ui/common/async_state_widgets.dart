// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueExtention<T> on AsyncValue<T> {
  Widget on({
    required BuildContext context,
    required Widget Function(T data) success,
    Widget Function(Object error) error = buidErrorWidget,
    Widget Function(BuildContext context) loading = buildLoadingWidget,
  }) {
    print("Render ListvView");
    return when(
      data: success,
      error: (e, stackTrace) => error(e),
      loading: () => loading(context),
    );
  }
}

Widget buildLoadingWidget(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  final top = MediaQuery.of(context).padding.top;
  final appBarHeight = top + kToolbarHeight;
  return SingleChildScrollView(
    child: SizedBox(
      width: size.width,
      height: size.height - appBarHeight,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
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
