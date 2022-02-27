// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrofit/retrofit.dart';

// 🌎 Project imports:
import 'package:my_flutter_playground/api/api_client.dart';
import 'package:my_flutter_playground/data/search_result.dart';

part 'search_api.g.dart';

final searchApiProvider = Provider((ref) => SearchApi.withReader(ref.read));

@RestApi(baseUrl: "https://api.github.com")
abstract class SearchApi {
  factory SearchApi.withReader(Reader reader) => SearchApi(reader(dioProvider));
  factory SearchApi(Dio dio) = _SearchApi;

  @GET("/search/repositories")
  Future<SearchResult> search(
      @Query("q") String query, @Query("page") int page);
}
