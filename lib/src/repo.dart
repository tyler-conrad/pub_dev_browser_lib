import 'package:pub_api_client/pub_api_client.dart' as pac;
import 'package:github/github.dart' as gh;

import 'parsed_search.dart' as ps;
import 'package_score.dart' as ps;

/// Repository that interacts with the pub.dev and GitHub APIs.
///
/// The [Repo] class is a wrapper around the [pac.PubClient] and [gh.GitHub]
/// clients. It provides methods to search for packages, get package
/// information, and get scores. The [Repo] is used throughout the application
/// to provide the data layer for the UI.
class Repo {
  final pubClient = pac.PubClient(debug: true);
  final githubClient = gh.GitHub();

  Future<List<String>> packageNames() async {
    return await pubClient.packageNameCompletion();
  }

  Future<pac.SearchResults> packageSearch(ps.ParsedSearch parsedSearch) async {
    return await pubClient.search(
      parsedSearch.query,
      sort: parsedSearch.sort,
      tags: parsedSearch.tags,
      topics: parsedSearch.topics,
    );
  }

  Future<pac.PubPackage> packageInfo(String packageName) async {
    return await pubClient.packageInfo(packageName);
  }

  Future<ps.PackageScore> packageScore(String packageName) async {
    return ps.PackageScore(await pubClient.packageScore(packageName));
  }

  Future<pac.PackageMetrics?> packageMetrics(String packageName) async {
    return await pubClient.packageMetrics(packageName);
  }
}
