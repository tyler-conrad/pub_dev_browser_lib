import 'dart:async' as async;
import 'package:flutter/material.dart' as m;

import 'package:flutter_svg/flutter_svg.dart' as fsvg;

import '../routes.dart' as r;

/// A splash screen that displays the pub.dev Dart logo.
///
/// Displayed on initial launch of the application.
class SplashScreen extends m.StatelessWidget {
  const SplashScreen({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    async.Timer(const Duration(seconds: 1), () {
      if (context.mounted) {
        const r.SearchRouteData().go(context);
      }
    });
    return m.FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.8,
      child: m.Center(
        child: fsvg.SvgPicture.asset('assets/pub-dev-logo.svg'),
      ),
    );
  }
}
