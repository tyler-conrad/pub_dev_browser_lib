import 'package:flutter/material.dart' as m;

/// The style of a particular segment of text in the search field.
sealed class Style {
  const Style();
}

/// The style of the search text.
class SearchStyle extends Style {
  const SearchStyle({required this.style});

  final m.TextStyle style;
}

/// The style of a qualifier in the search text.
class QualifierStyle extends Style {
  const QualifierStyle({required this.key, required this.value});

  final m.TextStyle key;
  final m.TextStyle value;
}

/// Represents a [RegExp] delimiting a search field qualifier.
sealed class _SearchFieldQualifier {
  const _SearchFieldQualifier(this.regExp);

  final String regExp;
}

/// A search field qualifier for the `dependency` tag.
class _DependencySearchFieldQualifier extends _SearchFieldQualifier {
  const _DependencySearchFieldQualifier()
      : super(r'^(dependency)(:)([\w|\-]+)$');
}

/// A search field qualifier for the `has` tag.
class _HasSearchFieldQualifier extends _SearchFieldQualifier {
  const _HasSearchFieldQualifier() : super(r'^(has)(:)(\w+)$');
}

/// A search field qualifier for the `is` tag.
class _IsSearchFieldQualifier extends _SearchFieldQualifier {
  const _IsSearchFieldQualifier() : super(r'^(is)(:)([\w|-]+)$');
}

/// A search field qualifier for the `license` tag.
class _LicenseSearchFieldQualifier extends _SearchFieldQualifier {
  const _LicenseSearchFieldQualifier() : super(r'^(license)(:)([\w|-]+)$');
}

/// A search field qualifier for the `platform` tag.
class _PlatformSearchFieldQualifier extends _SearchFieldQualifier {
  const _PlatformSearchFieldQualifier()
      : super(r'^(platform)(:)(android|ios|linux|macos|windows|web)$');
}

/// A search field qualifier for the `publisher` tag.
class _PublisherSearchFieldQualifier extends _SearchFieldQualifier {
  const _PublisherSearchFieldQualifier()
      : super(r'^(publisher)(:)([\w|-|\.]+)$');
}

/// A search field qualifier for the `sdk` tag.
class _SdkSearchFieldQualifier extends _SearchFieldQualifier {
  const _SdkSearchFieldQualifier() : super(r'^(sdk)(:)(flutter|dart)$');
}

/// A search field qualifier for the `show` tag.
class _ShowSearchFieldQualifier extends _SearchFieldQualifier {
  const _ShowSearchFieldQualifier() : super(r'^(show)(:)(\w+)$');
}

/// A search field qualifier for the `topic` tag.
class _TopicSearchFieldQualifier extends _SearchFieldQualifier {
  const _TopicSearchFieldQualifier() : super(r'(topic)(:)([\w|\-]+)');
}

/// A search field qualifier for the `sort` tag.
class _SortSearchFieldQualifier extends _SearchFieldQualifier {
  const _SortSearchFieldQualifier()
      : super(r'^(sort)(:)(top|text|created|updated|popularity|likes|points)$');
}

/// The query text of the search field.
class _TextSearch extends _SearchFieldQualifier {
  const _TextSearch() : super(r'^(.*)$');
}

/// A [TextEditingController] for the search field.
///
/// This controller provides syntax highlighting for the search field
/// qualifiers and query text. The qualifiers are colored differently from the
/// query text to provide a visual distinction between the two. The qualifiers
/// are also styled differently from each other.
class SearchFieldTextEditingController extends m.TextEditingController {
  SearchFieldTextEditingController({super.text});
  static final whitespaceRegExp = RegExp(r'\s');

  static const qualifiers = [
    _DependencySearchFieldQualifier(),
    _HasSearchFieldQualifier(),
    _IsSearchFieldQualifier(),
    _LicenseSearchFieldQualifier(),
    _PlatformSearchFieldQualifier(),
    _PublisherSearchFieldQualifier(),
    _SdkSearchFieldQualifier(),
    _ShowSearchFieldQualifier(),
    _TopicSearchFieldQualifier(),
    _SortSearchFieldQualifier(),
    _TextSearch()
  ];

  List<String> allMatchesWithSep(String input, RegExp regExp, [int start = 0]) {
    var result = <String>[];
    for (var match in regExp.allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      result.add(match[0]!);
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }

  @override
  m.TextSpan buildTextSpan({
    required m.BuildContext context,
    m.TextStyle? style,
    required bool withComposing,
  }) {
    final colorScheme = m.Theme.of(context).colorScheme;
    final children = <m.TextSpan>[];

    for (final part in allMatchesWithSep(text, whitespaceRegExp)) {
      final qualifier =
          qualifiers.firstWhere((q) => RegExp(q.regExp).hasMatch(part));
      final match = RegExp(qualifier.regExp).firstMatch(part);

      final styles = switch (qualifier) {
        _DependencySearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _HasSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _IsSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _LicenseSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _PlatformSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _PublisherSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _SdkSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _ShowSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.secondary),
            value: m.TextStyle(color: colorScheme.primary),
          ),
        _TopicSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.outline),
            value: m.TextStyle(color: colorScheme.tertiary),
          ),
        _SortSearchFieldQualifier() => QualifierStyle(
            key: m.TextStyle(color: colorScheme.outline),
            value: m.TextStyle(color: colorScheme.tertiaryContainer),
          ),
        _TextSearch() => SearchStyle(
            style: m.TextStyle(color: colorScheme.primaryContainer),
          ),
      };

      switch (styles) {
        case SearchStyle(:final style):
          if (part == '') {
            children.add(m.TextSpan(
              text: '',
              style: style,
            ));
          } else if (whitespaceRegExp.hasMatch(part)) {
            children.add(m.TextSpan(
              text: part,
              style: style,
            ));
          } else {
            children.add(m.TextSpan(
              text: part,
              style: m.TextStyle(color: colorScheme.primaryContainer),
            ));
          }
          break;
        case QualifierStyle(:final key, :final value):
          children.add(m.TextSpan(
            text: match?.group(1),
            style: key,
          ));

          children.add(m.TextSpan(
            text: match?.group(2),
            style: m.TextStyle(color: colorScheme.primaryContainer),
          ));

          children.add(m.TextSpan(
            text: match?.group(3),
            style: value,
          ));
          break;
      }
    }
    return m.TextSpan(style: style, children: children);
  }
}
