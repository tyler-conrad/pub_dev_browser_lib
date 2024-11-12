import 'package:flutter/material.dart' as m;

import 'package:flutter_bloc/flutter_bloc.dart' as fb;
import 'package:pub_api_client/pub_api_client.dart' as pac;
import 'package:flutter_svg/flutter_svg.dart' as fsvg;
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:markdown/markdown.dart' as md;

import '../common.dart' as c;
import '../repo.dart' as r;
import '../bloc/package_details_bloc.dart' as pdb;
import '../themed_text.dart' as tt;
import '../package_score.dart' as ps;
import '../routes.dart' as r;
import '../bloc/readme_bloc.dart' as rmb;
import '../code_highlighter.dart' as chl;
import 'labeled_divider_widget.dart' as ldw;
import 'segmented_buttons_widget.dart' as sb;

/// Represents the state of a segmented button item that contains an icon, icon
/// color and label.
typedef SegmentConfig = ({String iconPath, m.Color? color, String label});

/// [SegmentConfig]s for the Dart and Flutter SDKs.
final _sdkConfigs = <String, SegmentConfig>{
  'dart': (iconPath: 'assets/dart-logo.svg', color: null, label: 'Dart'),
  'flutter': (
    iconPath: 'assets/flutter-logo.svg',
    color: null,
    label: 'Flutter',
  ),
};

/// [SegmentConfig]s for the various platforms that a package supports.
final _platformConfigs = {
  'android': (
    iconPath: 'assets/android-logo.svg',
    color: null,
    label: 'Android',
  ),
  'ios': (iconPath: 'assets/ios-logo.svg', color: m.Colors.white, label: 'iOS'),
  'linux': (iconPath: 'assets/linux-logo.svg', color: null, label: 'Linux'),
  'macos': (
    iconPath: 'assets/macos-logo.svg',
    color: m.Colors.white,
    label: 'macOS'
  ),
  'windows': (
    iconPath: 'assets/windows-logo.svg',
    color: null,
    label: 'Windows',
  ),
  'web': (iconPath: 'assets/web-logo.svg', color: null, label: 'Web'),
};

/// A segmented button child that contains an icon, icon color and label.
///
/// The configuration for the segment is passed in via the [config] parameter.
/// Icon assets for the different platforms and SDKs are spcecified in the
/// [config]s iconPath field.  The icons are SVG files rendered using
/// 'flutter_svg'.
class Segment extends m.StatelessWidget {
  const Segment({super.key, required this.config});

  final SegmentConfig config;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Row(
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
            colorFilter: config.color == null
                ? null
                : m.ColorFilter.mode(config.color!, m.BlendMode.srcIn),
          ),
        ),
        m.Padding(
          padding: m.EdgeInsets.only(right: c.innerPadding),
          child: tt.ThemedText.bodyMedium()(config.label),
        ),
      ],
    );
  }
}

/// A row of segments that represent either the SDKs or platforms that a package
/// supports.
class SdkPlatformSegments extends m.StatelessWidget {
  const SdkPlatformSegments({super.key, required this.score});

  final ps.PackageScore score;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Row(
        mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
        children: [
          sb.SegmentedButtons(
            children: [
              ...score.tags.sdks.map((sdk) => _sdkConfigs[sdk]!).map((config) {
                return Segment(config: config);
              }),
            ],
          ),
          sb.SegmentedButtons(
            children: [
              ...score.tags.platforms
                  .map((platform) => _platformConfigs[platform]!)
                  .map((config) {
                return Segment(config: config);
              }),
            ],
          ),
        ]);
  }
}

/// A centered rendering of the dependencies that a package has.
///
/// Each dependency is tappable and will navigate to the package details screen
/// for that dependency.
class Dependencies extends m.StatelessWidget {
  const Dependencies({super.key, required this.dependencies});

  final List<String> dependencies;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        ldw.LabeledDivider(label: 'Dependencies'),
        m.Wrap(
          alignment: m.WrapAlignment.center,
          children: [
            for (final dep in dependencies)
              m.Padding(
                padding: m.EdgeInsets.all(c.itemPadding),
                child: c.Tappable(
                    onPressed: () {
                      r.PackageRouteData(dep).push(context);
                    },
                    child: tt.ThemedText.bodySmall(
                      style: m.TextStyle(
                        fontWeight: m.FontWeight.w300,
                      ),
                    )(dep)),
              ),
          ],
        )
      ],
    );
  }
}

/// Displays the points, likes and popularity score for a package.
///
/// The popularity score is optional and will only be displayed if it is not
/// null.
class ScoreSummary extends m.StatelessWidget {
  const ScoreSummary({super.key, required this.score});

  final ps.PackageScore score;

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    return m.Column(
      children: [
        ldw.LabeledDivider(label: 'Package Score'),
        m.Row(
          mainAxisAlignment: m.MainAxisAlignment.spaceAround,
          mainAxisSize: m.MainAxisSize.max,
          children: [
            m.Column(
              children: [
                tt.ThemedText.displaySmall(
                  style: m.TextStyle(color: colorScheme.primary),
                )('${score.grantedPoints}'),
                tt.ThemedText.bodyLarge(
                  style: m.TextStyle(color: colorScheme.outline),
                )('PUB POINTS'),
              ],
            ),
            m.Column(
              children: [
                tt.ThemedText.displaySmall(
                  style: m.TextStyle(color: colorScheme.primary),
                )('${score.likeCount}'),
                tt.ThemedText.bodyLarge(
                  style: m.TextStyle(color: colorScheme.outline),
                )('LIKES'),
              ],
            ),
            if (score.popularityScore != null)
              m.Column(
                children: [
                  tt.ThemedText.displaySmall(
                    style: m.TextStyle(color: colorScheme.primary),
                  )('${(score.popularityScore! * 100.0).toStringAsFixed(0)}%'),
                  tt.ThemedText.bodyLarge(
                    style: m.TextStyle(color: colorScheme.outline),
                  )('POPULARITY'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// Displays the package name, version, published date and publisher.
///
/// Additionally, if the package has a score, the SDKs and platforms that the
/// package supports are displayed and the scores for a package are shown.
class PackageDetailsHeader extends m.StatelessWidget {
  const PackageDetailsHeader(
      {super.key, required this.info, required this.metrics});

  final pac.PubPackage info;
  final pac.PackageMetrics? metrics;

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    final packageScore =
        metrics == null ? null : ps.PackageScore(metrics!.score);
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        m.Row(
          crossAxisAlignment: m.CrossAxisAlignment.end,
          children: [
            tt.ThemedText.displaySmall()(info.name),
            m.SizedBox(width: c.itemPadding),
            tt.ThemedText.headlineMedium(
              style: m.TextStyle(color: colorScheme.outline),
            )(info.latest.version),
          ],
        ),
        m.Row(
          children: [
            tt.ThemedText.headlineSmall(
                    style: m.TextStyle(color: colorScheme.outline))(
                'Published ${c.humanizeDuration(
              DateTime.now().toUtc().difference(info.latest.published),
            )}'),
            tt.ThemedText.headlineSmall(
                style: m.TextStyle(color: colorScheme.outline))(' - '),
            tt.ThemedText.headlineSmall(
                    style: m.TextStyle(color: colorScheme.primary))(
                packageScore == null ? '' : packageScore.tags.publisher),
          ],
        ),
        if (packageScore != null) m.SizedBox(height: c.itemPadding),
        if (packageScore != null)
          m.Padding(
            padding: m.EdgeInsets.only(top: c.itemPadding),
            child: SdkPlatformSegments(score: packageScore),
          ),
        if (packageScore != null) ScoreSummary(score: packageScore),
        if (metrics?.scorecard.panaReport?.allDependencies != null)
          Dependencies(
            dependencies: metrics!.scorecard.panaReport!.allDependencies!,
          ),
      ],
    );
  }
}

/// Base widget for the package details screen.
///
/// Uses the [pdb.PackageDetailsBloc] to retrieve data for the package and the
/// [rmb.ReadmeBloc] to fetch the README from GitHub if available. The markdown
/// of the Readme is rendered using the 'flutter_markdown' package.
class PackageScreen extends m.StatelessWidget {
  final String packageName;

  const PackageScreen({super.key, required this.packageName});
  @override
  m.Widget build(m.BuildContext context) {
    return m.SingleChildScrollView(
      child: fb.BlocProvider(
        create: (context) => pdb.PackageDetailsBloc(
          context.read<r.Repo>(),
        )..add(
            pdb.PackageDetailsRequested(packageName),
          ),
        child: fb.BlocBuilder<pdb.PackageDetailsBloc, pdb.PackageDetailsState>(
          builder: (context, state) {
            switch (state) {
              case pdb.PackageDetailsInitial():
                return const m.Center(child: m.CircularProgressIndicator());
              case pdb.PackageDetailsLoading():
                return const m.Center(child: m.CircularProgressIndicator());
              case pdb.PackageDetailsSuccess(:final info, :final metrics):
                return m.Padding(
                  padding: m.EdgeInsets.only(
                    left: c.horizontalInset,
                    top: c.itemPadding,
                    right: c.horizontalInset,
                  ),
                  child: m.Column(
                    children: [
                      PackageDetailsHeader(info: info, metrics: metrics),
                      m.Padding(
                        padding: m.EdgeInsets.only(
                          top: c.itemPadding,
                          bottom: c.itemPadding,
                        ),
                        child: m.Divider(),
                      ),
                      fb.BlocProvider(
                        create: (context) {
                          final host = info.latestPubspec.repository?.host;
                          final owner =
                              info.latestPubspec.repository?.pathSegments[0];
                          final name =
                              info.latestPubspec.repository?.pathSegments[1];
                          if (owner != null &&
                              name != null &&
                              host == 'github.com') {
                            return rmb.ReadmeBloc(
                              context.read<r.Repo>(),
                            )..add(
                                rmb.ReadmeRequested(owner: owner, name: name),
                              );
                          } else {
                            return rmb.ReadmeBloc(context.read<r.Repo>());
                          }
                        },
                        child: fb.BlocBuilder<rmb.ReadmeBloc, rmb.ReadmeState>(
                          builder: (context, state) {
                            final theme = m.Theme.of(context);
                            switch (state) {
                              case rmb.ReadmeInitial():
                                return m.SizedBox.shrink();
                              case rmb.ReadmeLoading():
                                return m.SizedBox.shrink();
                              case rmb.ReadmeSuccess(:final data):
                                return fmd.MarkdownBody(
                                  data: data,
                                  styleSheet:
                                      fmd.MarkdownStyleSheet.fromTheme(theme)
                                          .copyWith(
                                    a: m.TextStyle(
                                      color: theme.colorScheme.primaryContainer,
                                    ),
                                    codeblockDecoration: m.BoxDecoration(
                                      color: theme.colorScheme.onPrimary,
                                      borderRadius:
                                          m.BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  extensionSet: md.ExtensionSet.gitHubWeb,
                                  imageBuilder: (uri, title, alt) {
                                    try {
                                      return fsvg.SvgPicture.network(
                                        uri.toString(),
                                        fit: m.BoxFit.contain,
                                      );
                                    } catch (_) {
                                      return m.Image.network(
                                        uri.toString(),
                                        fit: m.BoxFit.contain,
                                      );
                                    }
                                  },
                                  builders: {
                                    'code': chl.CodeElementBuilder(),
                                  },
                                );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
