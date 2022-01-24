import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_playground/model/search_result.dart';

void main() {
  test("Json parse test", () {
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
    expect(result.items.first.stargazersCount, 1);
    expect(result.items.first.forksCount, 2);
    expect(result.items.first.openIssuesCount, 3);
    expect(result.items.first.language, "C++");
  });
}
