import 'package:flutter/material.dart' as m;

import '../common.dart' as c;
import '../themed_text.dart' as tt;
import '../text_editing_controller_adapter.dart' as teca;

/// A button used throughout the application to select or deselect a tag, search
/// filter, platform or SDK.
///
/// Can optionally be initialized as [selected] or with an [onPressed] callback.
///
/// Used by the `SearchResultsScreenWidget`, `ToggleButtons` and
/// `DialogToggleButtons`, and `TagSelector` widgets.
///
class SelectableOutlinedButton extends m.StatefulWidget {
  const SelectableOutlinedButton({
    super.key,
    required this.label,
    required this.tags,
    required this.textEditingControllerAdapter,
    this.onPressed,
    this.selected = false,
  });

  final String label;
  final teca.TextEditingControllerAdapter textEditingControllerAdapter;
  final List<String> tags;
  final m.VoidCallback? onPressed;
  final bool selected;

  @override
  m.State<SelectableOutlinedButton> createState() =>
      SelectableOutlinedButtonState();
}

class SelectableOutlinedButtonState extends m.State<SelectableOutlinedButton> {
  bool hovered = false;
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    Future.delayed(Duration.zero, addRemoveTags);
  }

  void addRemoveTags() {
    if (selected) {
      widget.textEditingControllerAdapter.addTags(widget.tags);
    } else {
      widget.textEditingControllerAdapter.removeTags(widget.tags);
    }
  }

  @override
  m.Widget build(m.BuildContext context) {
    final theme = m.Theme.of(context);
    return m.Padding(
      padding:
          const m.EdgeInsets.only(right: c.itemPadding, bottom: c.itemPadding),
      child: m.MouseRegion(
        onEnter: (_) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            hovered = false;
          });
        },
        child: m.OutlinedButton(
          style: m.ButtonStyle(
            backgroundColor: m.WidgetStateProperty.resolveWith(
              (states) {
                if (selected) {
                  return theme.colorScheme.primary;
                } else if (states.contains(m.WidgetState.disabled)) {
                  return m.Colors.transparent;
                } else if (states.contains(m.WidgetState.hovered)) {
                  return theme.colorScheme.primaryContainer;
                } else {
                  return m.Colors.transparent;
                }
              },
            ),
            side: m.WidgetStateProperty.resolveWith(
              (state) {
                if (selected) {
                  return m.BorderSide(
                    color: theme.colorScheme.primaryContainer,
                  );
                } else if (state.contains(m.WidgetState.disabled)) {
                  return m.BorderSide(
                    color: theme.colorScheme.secondary,
                  );
                } else if (state.contains(m.WidgetState.hovered)) {
                  return m.BorderSide(
                    color: theme.colorScheme.secondaryFixed,
                  );
                } else {
                  return m.BorderSide(
                    color: theme.colorScheme.primaryContainer,
                  );
                }
              },
            ),
            shape: m.WidgetStateProperty.resolveWith(
              (states) => m.RoundedRectangleBorder(
                borderRadius: m.BorderRadius.circular(c.borderRadius),
              ),
            ),
          ),
          onPressed: () {
            if (widget.onPressed != null) {
              widget.onPressed!();
            }

            setState(() {
              selected = !selected;
            });

            addRemoveTags();
          },
          child: tt.ThemedText.bodySmall(
            style: m.TextStyle(
              color: hovered
                  ? theme.colorScheme.onPrimary
                  : selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primaryContainer,
            ),
          )(widget.label),
        ),
      ),
    );
  }
}

/// A factory function that returns a [SelectableOutlinedButton] widget.
///
/// Used to initialized a [SelectableOutlinedButton] with the required from a
/// [teca.TextEditingControllerAdapter] and a [RegExp].
SelectableOutlinedButton selectableOutlinedButton({
  required String label,
  required List<String> tags,
  required RegExp regExp,
  required teca.TextEditingControllerAdapter textEditingControllerAdapter,
}) {
  return SelectableOutlinedButton(
    label: label,
    tags: tags,
    textEditingControllerAdapter: textEditingControllerAdapter,
    selected: textEditingControllerAdapter.controller.text
        .split(' ')
        .any(regExp.hasMatch),
  );
}
