import 'package:dart_mappable/dart_mappable.dart';
import 'package:pub_api_client/pub_api_client.dart' as pac;

import 'common.dart' as c;

part 'generated/parsed_search.mapper.dart';

/// Represents a parsed search query.
///
/// Contains the query string, sort order, topics and tags to be used in a
/// search. The [ParsedSearchAdapter] can be used to access the tags in a more
/// structured way.
@MappableClass()
class ParsedSearch with ParsedSearchMappable {
  const ParsedSearch({
    this.query = '',
    this.sort = pac.SearchOrder.top,
    this.tags = const <String>[],
    this.topics = const <String>[],
  });

  final String query;
  final pac.SearchOrder sort;
  final List<String> tags;
  final List<String> topics;
}

/// Adapter for the [ParsedSearch] class.
///
/// Provides methods to modify the search query, sort order, and tags in a more
/// structured way. The tags are parsed into different categories and can be
/// accessed using the methods provided by this class.
@MappableClass()
class ParsedSearchAdapter with ParsedSearchAdapterMappable {
  ParsedSearchAdapter(ParsedSearch parsedSearch) : _parsedSearch = parsedSearch;

  ParsedSearch _parsedSearch;

  String query([String? newQuery]) {
    _parsedSearch =
        _parsedSearch.copyWith(query: newQuery ?? _parsedSearch.query);
    return _parsedSearch.query;
  }

  pac.SearchOrder searchOrder([pac.SearchOrder? searchOrder]) {
    _parsedSearch =
        _parsedSearch.copyWith(sort: searchOrder ?? _parsedSearch.sort);
    return _parsedSearch.sort;
  }

  ParsedSearchAdapter addTags(List<String> newTags) {
    _parsedSearch = _parsedSearch.copyWith(
        tags: {..._parsedSearch.tags, ...newTags}.toList());
    return ParsedSearchAdapter(_parsedSearch);
  }

  List<String> tags() => _parsedSearch.tags;

  List<String> topics() => _parsedSearch.topics;

  Iterable<String> _matchingTags(RegExp tagRegExp) => _parsedSearch.tags.where(
        (tag) => tagRegExp.hasMatch(tag),
      );

  Iterable<String> dependencies() => _matchingTags(c.dependencyRegExp);
  Iterable<String> has() => _matchingTags(c.hasRegExp);
  Iterable<String> isA() => _matchingTags(c.isRegExp);
  Iterable<String> licenses() => _matchingTags(c.licenseRegExp);
  Iterable<String> platforms() => _matchingTags(c.platformRegExp);
  String publisher() => _matchingTags(c.publisherRegExp).firstOrNull ?? '';
  Iterable<String> sdks() => _matchingTags(c.sdkRegExp);
  Iterable<String> show() => _matchingTags(c.showRegExp);
  Iterable<String> topicTags() => _parsedSearch.topics.map((t) => 'topic:$t');
}
