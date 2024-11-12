import 'package:flutter/material.dart' as m;

import '../common.dart' as c;
import '../intersprese_iterable_extension.dart';

/// A composite button represented by a rounded box where each child is
/// separated horizontally by a vertical line.
///
/// Used by the `SdkPlatformSegments` and the `SearchResultsScreenWidget`.
class SegmentedButtons extends m.StatelessWidget {
  const SegmentedButtons({
    super.key,
    required this.children,
    this.innerPadding = 2.0,
  });

  final List<m.Widget> children;
  final double innerPadding;

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;

    return m.Container(
      decoration: m.BoxDecoration(
        color: colorScheme.onPrimary,
        border: m.Border.all(color: colorScheme.primaryContainer),
        borderRadius: m.BorderRadius.circular(c.borderRadius),
      ),
      child: m.Padding(
        padding: m.EdgeInsets.all(innerPadding),
        child: m.Row(
          mainAxisSize: m.MainAxisSize.min,
          children: children
              .intersperse(
                m.Padding(
                  padding: m.EdgeInsets.only(
                    left: innerPadding,
                    right: innerPadding,
                  ),
                  child: m.Container(
                    width: 1.0,
                    height: 12.0,
                    color: colorScheme.primaryContainer,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
