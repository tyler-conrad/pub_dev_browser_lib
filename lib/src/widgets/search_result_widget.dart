import 'package:flutter/gestures.dart' as g;
import 'package:flutter/material.dart' as m;

import 'package:flutter_bloc/flutter_bloc.dart' as fb;
import 'package:flutter_svg/flutter_svg.dart' as fsvg;
import 'package:pub_api_client/pub_api_client.dart' as pac;

import '../intersprese_iterable_extension.dart';
import '../common.dart' as c;
import '../repo.dart' as repo;
import '../themed_text.dart' as tt;
import '../routes.dart' as r;
import '../package_score.dart' as ps;
import '../bloc/package_result_bloc.dart' as prb;
import 'labeled_divider_widget.dart' as ld;
import 'segmented_buttons_widget.dart' as sb;
import '../text_editing_controller_adapter.dart' as teca;

const double verticalPadding = c.itemPadding * 2.0;

/// A score for either likes, points, or popularity.
///
/// Displays the score label and the score itself vertically in a column.
class Score extends m.StatelessWidget {
  const Score({
    super.key,
    required this.score,
    required this.label,
  });

  final String score;
  final String label;

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.center,
      children: [
        tt.ThemedText.bodySmall()(score),
        tt.ThemedText.bodySmall(
          style: m.TextStyle(color: colorScheme.outline),
        )(label),
      ],
    );
  }
}

/// A group of [Score] widgets that display the like count, granted points, and
/// popularity score.
///
/// The [Score] widgets are arranged horizontally in a row.
class ScoreCard extends m.StatelessWidget {
  const ScoreCard(this.score, {super.key});

  final ps.PackageScore score;

  @override
  m.Widget build(m.BuildContext context) {
    return m.SizedBox(
      height: 32.0,
      child: m.Row(
        crossAxisAlignment: m.CrossAxisAlignment.stretch,
        children: [
          Score(score: score.likeCount.toString(), label: 'Likes'),
          const m.VerticalDivider(),
          Score(score: score.grantedPoints.toString(), label: 'Points'),
          if (score.popularityScore != null) const m.VerticalDivider(),
          if (score.popularityScore != null)
            Score(
              score: '${(score.popularityScore! * 100.0).toStringAsFixed(0)}%',
              label: 'Popularity',
            ),
        ],
      ),
    );
  }
}

/// The URL of the publisher displayed as a tappable link.
///
/// Selecting the URL will add the publisher tag to the search query.
class PublisherLink extends m.StatelessWidget {
  const PublisherLink(
      {super.key, required this.publisher, required this.onPressed});

  final String publisher;
  final m.VoidCallback onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return c.Tappable(
      onPressed: onPressed,
      child: tt.ThemedText.bodySmall()(publisher),
    );
  }
}

/// A [SegmentedIconLabelButtons] segment that displays an icon and a label.
///
/// The button is tappable and will execute the [onPressed] callback when
/// selected.
class IconLabelButtonSegment extends m.StatelessWidget {
  const IconLabelButtonSegment(
      {super.key, required this.config, required this.onPressed});

  final SegmentedButtonConfig config;
  final m.VoidCallback onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return c.Tappable(
      onPressed: () {
        onPressed();
      },
      child: m.Row(
        mainAxisSize: m.MainAxisSize.min,
        children: [
          m.Padding(
            padding: const m.EdgeInsets.only(
              left: c.innerPadding,
              right: c.innerPadding,
            ),
            child: fsvg.SvgPicture.asset(
              config.iconPath,
              width: 12.0,
              height: 12.0,
              colorFilter: config.iconColor == null
                  ? null
                  : m.ColorFilter.mode(
                      config.iconColor!,
                      m.BlendMode.srcIn,
                    ),
            ),
          ),
          m.Padding(
            padding: const m.EdgeInsets.only(right: c.innerPadding),
            child: tt.ThemedText.bodyMedium()(config.label),
          ),
        ],
      ),
    );
  }
}

/// The type for the configuration of a [SegmentedIconLabelButtons] widget.
typedef SegmentedButtonConfig = ({
  String iconPath,
  m.Color? iconColor,
  String label,
  m.VoidCallback onPressed,
});

/// A row of [IconLabelButtonSegment]s that display an icon and a label for each
/// button separated by a vertical line.
class SegmentedIconLabelButtons extends m.StatelessWidget {
  const SegmentedIconLabelButtons({
    super.key,
    required this.tags,
    required this.configs,
  });

  final List<String> tags;
  final Map<String, SegmentedButtonConfig> configs;

  @override
  m.Widget build(m.BuildContext context) {
    return sb.SegmentedButtons(
      children: tags.map<m.Widget>(
        (tag) {
          final config = configs[tag]!;
          return IconLabelButtonSegment(
            config: config,
            onPressed: config.onPressed,
          );
        },
      ).toList(),
    );
  }
}

/// A widget that displays the version of a package.
class Version extends m.StatelessWidget {
  const Version({super.key, required this.version});

  final String version;

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;

    return m.Padding(
      padding: const m.EdgeInsets.only(right: c.itemPadding),
      child: m.DecoratedBox(
        decoration: m.BoxDecoration(
            color: colorScheme.onPrimary,
            borderRadius: m.BorderRadius.circular(c.borderRadius)),
        child: m.Padding(
          padding: const m.EdgeInsets.fromLTRB(
            c.innerPadding,
            c.innerPadding * 0.25,
            c.innerPadding,
            c.innerPadding * 0.5,
          ),
          child: tt.ThemedText.bodySmall()(
            maxLines: 10,
            softWrap: true,
            'v$version',
          ),
        ),
      ),
    );
  }
}

/// Base widget for displaying a single search result with the corresponding
/// sub-widgets that display the platforms, SDKs, version, publisher, and score.
///
/// The widget is tappable and will navigate to the package route when the
/// [ld.LabeledDivider] label is tapped.  The widget will also add tags to the
/// search query when the corresponding sub-widgets are tapped.  The tags are
/// added to the search query using the [teca.TextEditingControllerAdapter].
class SearchResult extends m.StatefulWidget {
  const SearchResult({
    super.key,
    required this.packageName,
    required this.textEditingControllerAdapter,
  });

  final String packageName;
  final teca.TextEditingControllerAdapter textEditingControllerAdapter;

  @override
  m.State createState() => SearchResultState();
}

class SearchResultState extends m.State<SearchResult> {
  bool packageDataVisible = false;

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    return m.Padding(
      padding: const m.EdgeInsets.only(
        left: c.horizontalInset,
        right: c.horizontalInset,
      ),
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children: [
          ld.LabeledDivider(
              label: widget.packageName,
              topPadding: 0.0,
              onPressed: () {
                r.PackageRouteData(widget.packageName).push(context);
              }),
          fb.BlocProvider<prb.PackageResultBloc>(
            create: (context) => prb.PackageResultBloc(
              context.read<repo.Repo>(),
            )..add(
                prb.PackageResultRequested(widget.packageName),
              ),
            child:
                fb.BlocBuilder<prb.PackageResultBloc, prb.PackageResultState>(
              builder: (context, state) {
                switch (state) {
                  case prb.PackageResultInitial():
                    return const m.SizedBox.shrink();
                  case prb.PackageResultLoading():
                    return const m.SizedBox.shrink();
                  case prb.PackageResultSuccess(:final info, :final score):
                    Future.delayed(Duration.zero, () {
                      if (mounted) {
                        setState(() {
                          packageDataVisible = true;
                        });
                      }
                    });
                    return m.AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: packageDataVisible ? 1.0 : 0.0,
                      child: m.Column(
                        crossAxisAlignment: m.CrossAxisAlignment.start,
                        children: [
                          m.RichText(
                            text: m.TextSpan(
                              style: m.TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              text: c.removeNewlines(info.description),
                              children: [
                                ...score.tags.topics,
                                ...score.tags.isA.where((tag) =>
                                    tag == 'flutter-favorite' ||
                                    tag == 'dart3-compatible'),
                              ]
                                  .map<m.TextSpan>(
                                    (topic) => m.TextSpan(
                                      style: m.TextStyle(
                                          color: colorScheme.primaryContainer),
                                      text: '#$topic',
                                      recognizer: g.TapGestureRecognizer()
                                        ..onTap = () {
                                          switch (topic) {
                                            case 'flutter-favorite':
                                              widget
                                                  .textEditingControllerAdapter
                                                  .addTags([
                                                pac.PackageTag.isFlutterFavorite
                                              ]);
                                              break;
                                            case 'dart3-compatible':
                                              widget
                                                  .textEditingControllerAdapter
                                                  .addTags(
                                                      ['is:dart3-compatible']);
                                              break;
                                            default:
                                              widget
                                                  .textEditingControllerAdapter
                                                  .addTags(['topic:$topic']);
                                          }
                                        },
                                    ),
                                  )
                                  .intersperse(
                                    const m.TextSpan(text: ' '),
                                    beforeFirst: true,
                                  )
                                  .toList(),
                            ),
                          ),
                          const m.SizedBox(height: verticalPadding),
                          m.Row(
                            children: [
                              Version(version: info.version),
                              tt.ThemedText.bodySmall(
                                  style:
                                      m.TextStyle(color: colorScheme.outline))(
                                '(${c.humanizeDuration(
                                  DateTime.now()
                                      .toUtc()
                                      .difference(info.latest.published),
                                )})',
                              ),
                              const m.SizedBox(width: c.itemPadding),
                              PublisherLink(
                                publisher: score.tags.publisher,
                                onPressed: () {
                                  widget.textEditingControllerAdapter.addTags(
                                      ['publisher:${score.tags.publisher}']);
                                },
                              ),
                              const m.Expanded(child: m.SizedBox.shrink()),
                              ScoreCard(score),
                            ],
                          ),
                          const m.SizedBox(height: verticalPadding),
                          m.Row(
                            mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
                            children: [
                              SegmentedIconLabelButtons(
                                tags: score.tags.sdks,
                                configs: {
                                  'dart': (
                                    iconPath: 'assets/dart-logo.svg',
                                    iconColor: null,
                                    label: 'Dart',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags([pac.PackageTag.sdkDart]);
                                    },
                                  ),
                                  'flutter': (
                                    iconPath: 'assets/flutter-logo.svg',
                                    iconColor: null,
                                    label: 'Flutter',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags([pac.PackageTag.sdkFlutter]);
                                    },
                                  ),
                                },
                              ),
                              SegmentedIconLabelButtons(
                                tags: score.tags.platforms,
                                configs: {
                                  'android': (
                                    iconPath: 'assets/android-logo.svg',
                                    iconColor: null,
                                    label: 'Android',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags(
                                              [pac.PackageTag.platformAndroid]);
                                    },
                                  ),
                                  'ios': (
                                    iconPath: 'assets/ios-logo.svg',
                                    iconColor: m.Colors.white,
                                    label: 'iOS',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags(
                                              [pac.PackageTag.platformIos]);
                                    },
                                  ),
                                  'linux': (
                                    iconPath: 'assets/linux-logo.svg',
                                    iconColor: null,
                                    label: 'Linux',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags(
                                              [pac.PackageTag.platformLinux]);
                                    },
                                  ),
                                  'macos': (
                                    iconPath: 'assets/macos-logo.svg',
                                    iconColor: m.Colors.white,
                                    label: 'macOS',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags(
                                              [pac.PackageTag.platformMacos]);
                                    },
                                  ),
                                  'windows': (
                                    iconPath: 'assets/windows-logo.svg',
                                    iconColor: null,
                                    label: 'Windows',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags(
                                              [pac.PackageTag.platformWindows]);
                                    },
                                  ),
                                  'web': (
                                    iconPath: 'assets/web-logo.svg',
                                    iconColor: null,
                                    label: 'Web',
                                    onPressed: () {
                                      widget.textEditingControllerAdapter
                                          .addTags(
                                              [pac.PackageTag.platformWeb]);
                                    },
                                  ),
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          ),
          const m.SizedBox(height: verticalPadding),
        ],
      ),
    );
  }
}
