import 'package:collection/collection.dart' show IterableExtension;
import 'package:dart_mappable/dart_mappable.dart';
import 'package:pub_api_client/pub_api_client.dart' as pac;

import 'common.dart' as c;

part 'generated/package_score.mapper.dart';

/// Represents the tags of a package.
///
/// Meant to be used with the constructor [PackageTags.fromTagList] to parse a
/// list of tags into a [PackageTags] object.  Sorts the tags according to
/// lexiographic order, except for the [platforms] which are sorted with the
/// 'web' platform first.
@MappableClass()
class PackageTags with PackageTagsMappable {
  PackageTags({
    this.publisher = '',
    this.has = const [],
    this.sdks = const [],
    this.platforms = const [],
    this.runtimes = const [],
    this.isA = const [],
    this.licenses = const [],
    this.topics = const [],
  });

  PackageTags.fromTagList(List<String> tags)
      : this(
          publisher: c.publisherRegExp
                  .firstMatch(tags.firstWhere(
                    (tag) => c.publisherRegExp.hasMatch(tag),
                    orElse: () => '',
                  ))
                  ?.group(1) ??
              '',
          has: _tagsValues(tags, c.hasRegExp, defaultComparator),
          sdks: _tagsValues(tags, c.sdkRegExp, defaultComparator),
          platforms: _tagsValues(tags, c.platformRegExp, platformComparator),
          runtimes: _tagsValues(tags, c.runtimeRegExp, defaultComparator),
          isA: _tagsValues(tags, c.isRegExp, defaultComparator),
          licenses: _tagsValues(tags, c.licenseRegExp, defaultComparator),
          topics: _tagsValues(tags, c.topicRegExp, defaultComparator),
        );

  final String publisher;
  final List<String> has;
  final List<String> sdks;
  final List<String> platforms;
  final List<String> runtimes;
  final List<String> isA;
  final List<String> licenses;
  final List<String> topics;

  static int defaultComparator(String a, String b) => a.compareTo(b);

  static int platformComparator(String a, String b) => switch ((a, b)) {
        ('web', _) => 1,
        (_, 'web') => -1,
        _ => a.compareTo(b),
      };

  static List<String> _tagsValues(
    List<String> tags,
    RegExp tagRegExp,
    Comparator<String> comparator,
  ) =>
      tags
          .where((tag) => tagRegExp.hasMatch(tag))
          .map((tag) => tagRegExp.firstMatch(tag)!.group(1)!)
          .sorted(comparator)
          .toList();
}

/// Represents the score of a package.
///
/// Uses [PackageTags] to represent the [tags] field, [grantedPoints],
/// [maxPoints], [likeCount] and [popularityScore] are extracted from the
/// [pac.PackageScore] object.
@MappableClass()
class PackageScore with PackageScoreMappable {
  PackageScore(this.score)
      : grantedPoints = score.grantedPoints,
        maxPoints = score.maxPoints,
        likeCount = score.likeCount,
        popularityScore = score.popularityScore,
        tags = PackageTags.fromTagList(score.tags);

  final pac.PackageScore score;
  final int grantedPoints;
  final int maxPoints;
  final int likeCount;
  final double? popularityScore;
  final PackageTags tags;
}
