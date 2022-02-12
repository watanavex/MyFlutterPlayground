import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/api/api_client.dart';
import 'package:my_flutter_playground/data/repo_item.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'repository_api.g.dart';

final repositoryApiProvider =
    Provider((ref) => RepositoryApi.withReader(ref.read));

@RestApi(baseUrl: "https://api.github.com")
abstract class RepositoryApi {
  factory RepositoryApi.withReader(Reader reader) =>
      RepositoryApi(reader(dioProvider));
  factory RepositoryApi(Dio dio) = _RepositoryApi;

  @GET("/repos/{owner}/{repo}")
  Future<RepoItem> fetch(@Path() String owner, @Path() repo);
}
