import 'package:flutter/material.dart' as m;
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:markdown/markdown.dart' as md;

/// A [fmd.MarkdownElementBuilder] that builds a code block with Dart syntax
/// highlighting.
///
/// Used in displaying the `README.md` file retrieved from GitHub in the details
/// screen for a selected package.
class CodeElementBuilder extends fmd.MarkdownElementBuilder {
  @override
  m.Widget? visitElementAfter(md.Element element, m.TextStyle? preferredStyle) {
    var language = 'dart';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return HighlightView(
      element.textContent,
      language: language,
      theme: atomOneDarkTheme,
      padding: const m.EdgeInsets.all(2),
      textStyle: m.TextStyle(fontFamily: 'monospace', fontSize: 12),
    );
  }
}
