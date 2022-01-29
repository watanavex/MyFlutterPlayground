import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_flutter_playground/api/api_client.dart';
import 'package:my_flutter_playground/model/search_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'search_api.g.dart';

final searchApiProvider = Provider((ref) => SearchApi.withReader(ref.read));

@RestApi(baseUrl: "https://api.github.com")
abstract class SearchApi {
  factory SearchApi.withReader(Reader reader) => SearchApi(reader(dioProvider));
  factory SearchApi(Dio dio) = _SearchApi;

  @GET("/search/repositories")
  Future<SearchResult> search(@Query("q") String query);
}

// class _SearchApi2 implements SearchApi {
//   factory _SearchApi2(this._dio, {this.baseUrl}) {
//     baseUrl ??= 'https://api.github.com';
//   }

//   final Dio _dio;

//   String? baseUrl;

//   Future<SearchResult> search(@Query("q") String query) {
//     throw Error();
//   }
// }
