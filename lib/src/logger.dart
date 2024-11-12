import 'dart:developer' as dev;

import 'package:flutter/foundation.dart' as f;

import 'package:logger/logger.dart' as logger;

/// Configures the [logger.Logger] to [f.debugPrint] and [dev.log] the output.
class _ConsoleOutput extends logger.LogOutput {
  @override
  void output(logger.OutputEvent event) {
    for (var line in event.lines) {
      f.debugPrint(line);
      dev.log(line);
    }
  }
}

/// A [logger.Logger] instance that prints to the console and the dev tools.
///
/// This logger is used throughout the application to log messages to the
/// console. It is configured to print pretty messages with colors, no boxing
/// and no emojis.
final log = logger.Logger(
  printer: logger.PrettyPrinter(
    noBoxingByDefault: true,
    printEmojis: false,
  ),
  output: _ConsoleOutput(),
  level: logger.Level.trace,
);
