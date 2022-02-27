// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:my_flutter_playground/data/repo_detail.dart';
import 'package:my_flutter_playground/data/search_result.dart';

void main() {
  test("Json deserialize to SearchResult", () {
    var json = {
      "total_count": 40,
      "incomplete_results": false,
      "items": [
        {
          "name": "swift",
          "owner": {
            "login": "swift",
            "avatar_url":
                "https://avatars.githubusercontent.com/u/10639145?v=4",
          },
          "stargazers_count": 1,
          "forks_count": 2,
          "open_issues_count": 3,
          "language": "C++"
        }
      ]
    };
    var result = SearchResult.fromJson(json);
    expect(result.totalCount, 40);
    expect(result.incompleteResults, false);
    expect(result.items.length, 1);

    expect(result.items.first.name, "swift");
    expect(result.items.first.owner.avatarUrl,
        "https://avatars.githubusercontent.com/u/10639145?v=4");
    expect(result.items.first.owner.login, "swift");
  });

  test("Json deserialize to repo_detail", () {
    var json = {
      "name": "swift",
      "owner": {
        "login": "swift",
        "avatar_url": "https://avatars.githubusercontent.com/u/10639145?v=4",
      },
      "stargazers_count": 1,
      "forks_count": 2,
      "open_issues_count": 3,
      "subscribers_count": 4,
      "language": "C++",
      "description": "description"
    };

    var result = RepoDetail.fromJson(json);
    expect(result.name, "swift");
    expect(result.owner.avatarUrl,
        "https://avatars.githubusercontent.com/u/10639145?v=4");
    expect(result.owner.login, "swift");
    expect(result.stargazersCount, 1);
    expect(result.forksCount, 2);
    expect(result.openIssuesCount, 3);
    expect(result.subscribersCount, 4);
    expect(result.description, "description");
    expect(result.language, "C++");
  });
}
