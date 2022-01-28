import 'package:json_annotation/json_annotation.dart';
import 'package:my_flutter_playground/model/search_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'search_api.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class SearchApi {
  factory SearchApi(Dio dio) = _SearchApi;

  @GET("/search/repositories")
  Future<SearchResult> search(@Query("q") String query);
}
