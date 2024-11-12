import 'package:pub_api_client/pub_api_client.dart' as pac;

import 'common.dart' as c;
import 'parsed_search.dart' as ps;

/// Recoverable exception when the platform tag is invalid.
///
/// Valid platforms are `android`, `ios`, `linux`, `macos`, `windows`, and
/// `web`.
class InvalidPlatformException implements Exception {
  const InvalidPlatformException(this.platformTag);

  final String platformTag;

  @override
  String toString() => 'InvalidPlatformException($platformTag)';
}

/// Recoverable exception when the SDK tag is invalid.
///
/// Valid SDKs are `flutter` and `dart`.
class InvalidSdkTagException implements Exception {
  const InvalidSdkTagException(this.sdkTag);

  final String sdkTag;

  @override
  String toString() => 'InvalidSdkTagException($sdkTag)';
}

/// Recoverable exception when the sort specifier is invalid.
///
/// Valid sort specifiers are `top`, `text`, `created`, `updated`, `popularity`,
/// `likes`, and `points`.
class InvalidSortSpecifierException implements Exception {
  const InvalidSortSpecifierException(this.sortSpecifier);

  final String sortSpecifier;

  @override
  String toString() => 'InvalidSortSpecifierException($sortSpecifier)';
}

/// Recoverable exception when the number of sort specifiers is invalid.
///
/// Only one sort specifier is allowed.
class InvalidNumberOfSortsException implements Exception {
  const InvalidNumberOfSortsException(this.sorts);

  final List<String> sorts;

  @override
  String toString() => 'InvalidNumberOfSortsException($sorts)';
}

/// Parses the a `TextField` search query into a [ps.ParsedSearch] object.
///
/// The search query is split into parts and each part is checked for tags and
/// topics. The [ps.ParsedSearch] is used to configure the routing from the
/// search page and the search results page.
class SearchParser {
  const SearchParser(this.search);

  static final allSortsRegExp =
      RegExp(r'sort:(?:top|text|created|updated|popularity|likes|points)');

  final String search;

  /// Parses the search query into a [ps.ParsedSearch] object.
  ps.ParsedSearch parse() {
    /// Each search query split on whitespace.
    final parts = search.split(c.whitespaceRegExp);

    /// The part of the search that is not a topic or tag.
    final query = <String>[];

    /// The tags in the search query.
    final tags = <String>[];

    /// The topics in the search query.
    final topics = <String>[];
    pac.SearchOrder sort = pac.SearchOrder.top;
    int numSorts = 0;

    // For each part match against topics and tags eventually isolating the
    // unmatched parts into the "query" which are the search terms.
    for (final part in parts) {
      if (c.dependencyRegExp.hasMatch(part)) {
        tags.add(
          pac.PackageTag.dependency(
            c.dependencyRegExp.firstMatch(part)!.group(1)!,
          ),
        );
      } else if (c.hasRegExp.hasMatch(part)) {
        tags.add(
          pac.PackageTag.has(c.hasRegExp.firstMatch(part)!.group(1)!),
        );
      } else if (c.isRegExp.hasMatch(part)) {
        tags.add(
          pac.PackageTag.isTag(c.isRegExp.firstMatch(part)!.group(1)!),
        );
      } else if (c.licenseRegExp.hasMatch(part)) {
        tags.add(
          pac.PackageTag.license(c.licenseRegExp.firstMatch(part)!.group(1)!),
        );
      } else if (c.platformRegExp.hasMatch(part)) {
        final platformTag = c.platformRegExp.firstMatch(part)!;
        final platform = platformTag.group(1)!;
        switch (platform) {
          case 'android':
          case 'ios':
          case 'linux':
          case 'macos':
          case 'windows':
          case 'web':
            tags.add(pac.PackageTag.platform(platform));
            break;
          default:
            throw InvalidPlatformException(platformTag.group(0)!);
        }
      } else if (c.publisherRegExp.hasMatch(part)) {
        tags.add(
          pac.PackageTag.publisher(
            c.publisherRegExp.firstMatch(part)!.group(1)!,
          ),
        );
      } else if (c.sdkRegExp.hasMatch(part)) {
        final sdkTag = c.sdkRegExp.firstMatch(part)!;
        switch (sdkTag.group(1)!) {
          case 'flutter':
            tags.add(pac.PackageTag.sdkFlutter);
            break;
          case 'dart':
            tags.add(pac.PackageTag.sdkDart);
            break;
          default:
            throw InvalidSdkTagException(sdkTag.group(0)!);
        }
      } else if (c.showRegExp.hasMatch(part)) {
        tags.add(pac.PackageTag.show(c.showRegExp.firstMatch(part)!.group(1)!));
      } else if (c.topicRegExp.hasMatch(part)) {
        topics.add(c.topicRegExp.firstMatch(part)!.group(1)!);
      } else if (c.sortRegExp.hasMatch(part)) {
        numSorts++;
        final sortSpecifier = c.sortRegExp.firstMatch(part)!;
        switch (sortSpecifier.group(1)!) {
          case 'top':
            sort = pac.SearchOrder.top;
            break;
          case 'text':
            sort = pac.SearchOrder.text;
            break;
          case 'created':
            sort = pac.SearchOrder.created;
            break;
          case 'updated':
            sort = pac.SearchOrder.updated;
            break;
          case 'popularity':
            sort = pac.SearchOrder.popularity;
            break;
          case 'likes':
            sort = pac.SearchOrder.like;
            break;
          case 'points':
            sort = pac.SearchOrder.points;
            break;
          default:
            throw InvalidSortSpecifierException(sortSpecifier.group(0)!);
        }
      } else {
        query.add(part);
      }
    }

    // Only one sort specifier is allowed.
    if (numSorts != 1) {
      throw InvalidNumberOfSortsException(
        search.split(' ').where((part) => c.sortRegExp.hasMatch(part)).toList(),
      );
    }

    return ps.ParsedSearch(
      query: query.join(' ').trim(),
      tags: tags,
      topics: topics,
      sort: sort,
    );
  }
}
