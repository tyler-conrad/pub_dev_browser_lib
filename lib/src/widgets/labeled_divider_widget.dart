import 'package:flutter/material.dart' as m;

import '../common.dart' as c;
import '../themed_text.dart' as tt;

/// A widget with a label in the middle and two horizontal [m.Divider]s
/// on each side.
///
/// The label and indent from the edges of the [m.Divider]s is configurable. The
/// vertical padding can also be optionally be passed in. Supports an
/// `onPressed` callback that allows the label to be tappable.
class LabeledDivider extends m.StatelessWidget {
  const LabeledDivider({
    super.key,
    required this.label,
    this.indent = 0.0,
    this.topPadding = c.itemPadding,
    this.bottomPadding = c.itemPadding,
    this.onPressed,
  });

  final String label;
  final double indent;
  final double topPadding;
  final double bottomPadding;
  final m.VoidCallback? onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Padding(
      padding: m.EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: m.Row(
        children: [
          m.Expanded(
            child: m.Divider(
              indent: indent,
              endIndent: 8.0,
            ),
          ),
          c.Tappable(
            onPressed: onPressed,
            child: tt.ThemedText.titleMedium()(label),
          ),
          m.Expanded(
            child: m.Divider(
              indent: 8.0,
              endIndent: indent,
            ),
          ),
        ],
      ),
    );
  }
}
