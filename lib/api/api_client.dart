import 'package:dio/dio.dart';

// TODO: Include Provider
Dio provideDio() {
  final dio = Dio();
  // flutter run --debug --dart-define=FLAVOR=Production --dart-define=API_TOKEN=$GITHUB_ACCESS_TOKEN
  const apiToken = String.fromEnvironment("API_TOKEN");
  const flavor = String.fromEnvironment("FLAVOR");
  print("apiToken = $apiToken, $flavor");
  if (apiToken.isEmpty == false) {
    dio.options.headers["Authorization"] = "token $apiToken";
  }

  return dio;
}