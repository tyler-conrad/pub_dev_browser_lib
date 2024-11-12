import 'package:flutter/services.dart' as s;
import 'package:flutter/material.dart' as m;

/// Default horizontal screen inset for both the left and right sides.
const double horizontalInset = 32.0;

/// The default padding between widgets of several different types.
const double itemPadding = 8.0;

/// The padding between the visible edge of a widget and it's contents.
const double innerPadding = 4.0;

/// The default border radius for rounded widgets.
const double borderRadius = 4.0;

/// Removes all newline anc carriage return characters from the input string.
String removeNewlines(String input) {
  return input.replaceAll('\n', ' ').replaceAll('\r', '');
}

/// Matches whitespace characters.
final whitespaceRegExp = RegExp(r'\s+');

/// Matches a `dependency` filter.
final dependencyRegExp = RegExp(r'^dependency:([\w|\-]+)$');

/// Matches a `has` filter.
final hasRegExp = RegExp(r'^has:(\w+)$');

/// Matches a `is` filter.
final isRegExp = RegExp(r'^is:([\w|\-]+)$');

/// Matches a `license` filter.
final licenseRegExp = RegExp(r'^license:([\w|\-]+)$');

/// Matches a `platform` filter.
final platformRegExp = RegExp(r'^platform:(\w+)$');

/// Matches a `publisher` filter.
final publisherRegExp = RegExp(r'^publisher:([\w|\-|\.]+)$');

/// Matches a `sdk` filter.
final sdkRegExp = RegExp(r'^sdk:(\w+)$');

/// Matches a `show` filter.
final showRegExp = RegExp(r'^show:(\w+)$');

/// Matches a `topic` filter.
final topicRegExp = RegExp(r'^topic:([\w|\-]+)$');

/// Matches a `sort` filter.
final sortRegExp = RegExp(r'^sort:(\w+)$');

/// Matches a `runtime` filter.
final runtimeRegExp = RegExp(r'^runtime:([\w|\-]+)$');

/// Humanizes a [Duration] into a string.
///
/// Returns a string that represents the duration in a human readable format.
/// Uses the phrases 'years ago', 'months ago', 'days ago', 'hours ago',
/// 'minutes ago', and 'seconds ago' to represent the time elapsed.
String humanizeDuration(Duration duration) {
  if (duration.inDays > 365) {
    return '${(duration.inDays / 365.0).toStringAsFixed(0)} years ago';
  } else if (duration.inDays > 90) {
    return '${(duration.inDays / 30.0).toStringAsFixed(0)} months ago';
  } else if (duration.inDays > 0) {
    return '${duration.inDays} days ago';
  } else if (duration.inDays == 0 && duration.inHours > 0) {
    return '${duration.inHours} hours ago';
  } else if (duration.inDays == 0 &&
      duration.inHours == 0 &&
      duration.inMinutes > 0) {
    return '${duration.inMinutes} minutes ago';
  } else if (duration.inDays == 0 &&
      duration.inHours == 0 &&
      duration.inMinutes == 0 &&
      duration.inSeconds > 0) {
    return '${duration.inSeconds} seconds ago';
  } else {
    return '0 seconds ago';
  }
}

/// Generic widget representing any tappable widget.
///
/// Contains a child parameter and an optional onPressed parameter. Used in
/// various places throughout the application to make interactive widgets.

class Tappable extends m.StatelessWidget {
  const Tappable({
    super.key,
    required this.child,
    this.onPressed,
  });

  final m.Widget child;
  final m.VoidCallback? onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return m.MouseRegion(
      cursor: onPressed == null
          ? m.SystemMouseCursors.basic
          : m.SystemMouseCursors.click,
      child: m.GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}

m.FocusNode onEnterSubmitFocusNode(m.VoidCallback onEnter) {
  return m.FocusNode(
    onKeyEvent: (node, event) {
      final enterPressedWithoutShift = event is s.KeyDownEvent &&
          event.physicalKey == s.PhysicalKeyboardKey.enter &&
          !s.HardwareKeyboard.instance.physicalKeysPressed.any(
            (key) => <s.PhysicalKeyboardKey>{
              s.PhysicalKeyboardKey.shiftLeft,
              s.PhysicalKeyboardKey.shiftRight,
            }.contains(key),
          );

      if (enterPressedWithoutShift) {
        onEnter();
        return m.KeyEventResult.handled;
      } else if (event is s.KeyRepeatEvent) {
        // Disable holding enter
        return m.KeyEventResult.handled;
      } else {
        return m.KeyEventResult.ignored;
      }
    },
  );
}
