import 'package:flutter/material.dart' as m;

typedef GetStyleCallback = m.TextStyle Function(m.BuildContext);

/// Copies the properties of [selectedStyle] to [style] if they are not null.
///
/// If no [selectedStyle] is specified, [defaultStyle] is used.
m.TextStyle _copyOrDefault(
  m.TextStyle? style,
  m.TextStyle? selectedStyle,
  m.TextStyle defaultStyle,
) =>
    style?.copyWith(
      color: style.color ?? selectedStyle?.color,
      backgroundColor: style.backgroundColor ?? selectedStyle?.backgroundColor,
      fontSize: style.fontSize ?? selectedStyle?.fontSize,
      fontWeight: style.fontWeight ?? selectedStyle?.fontWeight,
      fontStyle: style.fontStyle ?? selectedStyle?.fontStyle,
      letterSpacing: style.letterSpacing ?? selectedStyle?.letterSpacing,
      wordSpacing: style.wordSpacing ?? selectedStyle?.wordSpacing,
      textBaseline: style.textBaseline ?? selectedStyle?.textBaseline,
      height: style.height ?? selectedStyle?.height,
      locale: style.locale ?? selectedStyle?.locale,
      foreground: style.foreground ?? selectedStyle?.foreground,
      background: style.background ?? selectedStyle?.background,
      shadows: style.shadows ?? selectedStyle?.shadows,
      fontFeatures: style.fontFeatures ?? selectedStyle?.fontFeatures,
      decoration: style.decoration ?? selectedStyle?.decoration,
      decorationColor: style.decorationColor ?? selectedStyle?.decorationColor,
      decorationStyle: style.decorationStyle ?? selectedStyle?.decorationStyle,
      decorationThickness:
          style.decorationThickness ?? selectedStyle?.decorationThickness,
      debugLabel: style.debugLabel ?? selectedStyle?.debugLabel,
      fontFamily: style.fontFamily ?? selectedStyle?.fontFamily,
      fontFamilyFallback:
          style.fontFamilyFallback ?? selectedStyle?.fontFamilyFallback,
    ) ??
    selectedStyle ??
    defaultStyle;

/// The type of a ThemedText constructor.
typedef ThemedTextCtor = ThemedText Function(
  String, {
  m.Key? key,
  m.TextAlign? textAlign,
  m.TextOverflow? textOverflow,
  int? maxLines,
  m.Locale? locale,
  m.Color? selectionColor,
  String? semanticLabel,
  bool? softWrap,
  m.StrutStyle? strutStyle,
  m.TextDirection? textDirection,
  m.TextHeightBehavior? textHeightBehavior,
  m.TextScaler? textScaler,
  m.TextWidthBasis? textWidthBasis,
});

/// Provides a [m.Text] widget with a theme-based style.
///
/// Provides named constructors for each of the Material Design font
/// definitions. The style is determined by the [getStyle] callback, which is
/// passed the [m.BuildContext] of the widget. Example usage:
/// ```dart
/// ThemedText.displayLarge(color: m.Colors.red)('Hello, world!');
/// ```
/// [m.BuildContext] of the widget.
class ThemedText extends m.StatelessWidget {
  final String text;
  final m.TextAlign? textAlign;
  final m.TextOverflow? overflow;
  final int? maxLines;
  final m.Locale? locale;
  final m.Color? selectionColor;
  final String? semanticLabel;
  final bool? softWrap;
  final m.StrutStyle? strutStyle;
  final m.TextDirection? textDirection;
  final m.TextHeightBehavior? textHeightBehavior;
  final m.TextScaler? textScaler;
  final m.TextWidthBasis? textWidthBasis;

  final GetStyleCallback getStyle;

  const ThemedText._(
    this.getStyle,
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.locale,
    this.selectionColor,
    this.semanticLabel,
    this.softWrap,
    this.strutStyle,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaler,
    this.textWidthBasis,
  });

  /// Static method meant to be the only way to create a [ThemedText] widget.
  static ThemedTextCtor _themedText(GetStyleCallback getStyle) => (
        String text, {
        m.Key? key,
        m.TextAlign? textAlign,
        m.TextOverflow? textOverflow,
        int? maxLines,
        m.Locale? locale,
        m.Color? selectionColor,
        String? semanticLabel,
        bool? softWrap,
        m.StrutStyle? strutStyle,
        m.TextDirection? textDirection,
        m.TextHeightBehavior? textHeightBehavior,
        m.TextScaler? textScaler,
        m.TextWidthBasis? textWidthBasis,
      }) =>
          ThemedText._(
            getStyle,
            text,
            key: key,
            textAlign: textAlign,
            overflow: textOverflow,
            maxLines: maxLines,
            locale: locale,
            selectionColor: selectionColor,
            semanticLabel: semanticLabel,
            softWrap: softWrap,
            strutStyle: strutStyle,
            textDirection: textDirection,
            textHeightBehavior: textHeightBehavior,
            textScaler: textScaler,
            textWidthBasis: textWidthBasis,
          );

  static ThemedTextCtor displayLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.displayLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor displayMedium({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.displayMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor displaySmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.displaySmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor headlineMedium({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.headlineMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor headlineSmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.headlineSmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor titleLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.titleLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor titleMedium({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.titleMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor titleSmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.titleSmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor bodyLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.bodyLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor bodyMedium({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.bodyMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor bodySmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.bodySmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor labelLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.labelLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor labelSmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).textTheme.labelSmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryDisplayLarge({m.TextStyle? style}) =>
      _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.displayLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryDisplayMedium({m.TextStyle? style}) =>
      _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.displayMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryDisplaySmall({m.TextStyle? style}) =>
      _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.displaySmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryHeadlineMedium({m.TextStyle? style}) =>
      _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.headlineMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryHeadlineSmall({m.TextStyle? style}) =>
      _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.headlineSmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryTitleLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.titleLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryTitleMedium({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.titleMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryTitleSmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.titleSmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryBodyLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.bodyLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryBodyMedium({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.bodyMedium,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryBodySmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.bodySmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryLabelLarge({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.labelLarge,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  static ThemedTextCtor primaryLabelSmall({m.TextStyle? style}) => _themedText(
        (m.BuildContext context) => _copyOrDefault(
          style,
          m.Theme.of(context).primaryTextTheme.labelSmall,
          m.DefaultTextStyle.of(context).style,
        ),
      );

  @override
  m.Widget build(m.BuildContext context) {
    return m.Text(
      text,
      style: getStyle(context),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      locale: locale,
      selectionColor: selectionColor,
      semanticsLabel: semanticLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textHeightBehavior: textHeightBehavior,
      textScaler: textScaler,
      textWidthBasis: textWidthBasis,
    );
  }
}
