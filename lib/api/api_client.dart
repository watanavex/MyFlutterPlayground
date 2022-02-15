import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  // flutter run --debug --dart-define=FLAVOR=Production --dart-define=API_TOKEN=$GITHUB_ACCESS_TOKEN
  const apiToken = String.fromEnvironment("API_TOKEN");
  const flavor = String.fromEnvironment("FLAVOR");
  print("apiToken = $apiToken, $flavor");
  // if (apiToken.isEmpty == false) {
  dio.options.headers["Authorization"] =
      "token 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";
  // }

  return dio;
});
