import 'package:flutter/material.dart' as m;

import 'package:pub_api_client/pub_api_client.dart' as pac;

import '../text_editing_controller_adapter.dart' as teca;
import 'selectable_outlined_button_widget.dart' as sobw;

/// [pac.SearchOrder] translated to a list of search filters.
List<String> tags(pac.SearchOrder key) => switch (key) {
      pac.SearchOrder.top => ['sort:top'],
      pac.SearchOrder.text => ['sort:text'],
      pac.SearchOrder.created => ['sort:created'],
      pac.SearchOrder.updated => ['sort:updated'],
      pac.SearchOrder.popularity => ['sort:popularity'],
      pac.SearchOrder.like => ['sort:likes'],
      pac.SearchOrder.points => ['sort:points'],
    };

/// [pac.SearchOrder] translated to a human readable label.
String label(pac.SearchOrder key) => switch (key) {
      pac.SearchOrder.top => 'Top',
      pac.SearchOrder.text => 'Text',
      pac.SearchOrder.created => 'Created',
      pac.SearchOrder.updated => 'Updated',
      pac.SearchOrder.popularity => 'Popularity',
      pac.SearchOrder.like => 'Likes',
      pac.SearchOrder.points => 'Points',
    };

/// A widget that displays a column of toggle buttons where each button
/// represents a search order.
class DialogToggleButtons extends m.StatelessWidget {
  const DialogToggleButtons({
    super.key,
    required this.toggleButtonsSelection,
    required this.textEditingControllerAdapter,
    required this.onPressed,
  });

  final Map<pac.SearchOrder, bool> toggleButtonsSelection;
  final teca.TextEditingControllerAdapter textEditingControllerAdapter;
  final void Function(pac.SearchOrder) onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Column(
      mainAxisSize: m.MainAxisSize.min,
      children: toggleButtonsSelection.entries
          .map(
            (entry) => sobw.SelectableOutlinedButton(
              key: m.ValueKey(entry),
              selected: entry.value,
              textEditingControllerAdapter: textEditingControllerAdapter,
              tags: tags(entry.key),
              label: label(entry.key),
              onPressed: () {
                onPressed(entry.key);
              },
            ),
          )
          .toList(),
    );
  }
}

/// A widget that displays a row of toggle buttons where each button represents
/// a search order.
class ToggleButtons extends m.StatelessWidget {
  const ToggleButtons({
    super.key,
    required this.toggleButtonsSelection,
    required this.textEditingControllerAdapter,
    required this.onPressed,
  });

  final Map<pac.SearchOrder, bool> toggleButtonsSelection;
  final teca.TextEditingControllerAdapter textEditingControllerAdapter;
  final void Function(pac.SearchOrder) onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Wrap(
      alignment: m.WrapAlignment.center,
      children: toggleButtonsSelection.entries
          .map(
            (entry) => sobw.SelectableOutlinedButton(
              key: m.ValueKey(entry),
              selected: entry.value,
              textEditingControllerAdapter: textEditingControllerAdapter,
              tags: tags(entry.key),
              label: label(entry.key),
              onPressed: () {
                onPressed(entry.key);
              },
            ),
          )
          .toList(),
    );
  }
}

/// Buttons to select a search order that are mutually exclusive.
///
/// The [SearchOrderToggleButtons] widget is a wrapper around the [ToggleButtons]
/// that maintains state about which button has been pressed and updates the
/// selection to only allow a single choice.
///
/// The [isDialog] parameter is used to determine the layout of the buttons.
class SearchOrderToggleButtons extends m.StatefulWidget {
  const SearchOrderToggleButtons({
    super.key,
    required this.textEditingControllerAdapter,
    required this.searchOrder,
    required this.isDialog,
    this.onPressed,
  });

  final teca.TextEditingControllerAdapter textEditingControllerAdapter;
  final pac.SearchOrder searchOrder;
  final bool isDialog;
  final m.VoidCallback? onPressed;

  @override
  m.State<SearchOrderToggleButtons> createState() =>
      SearchOrderToggleButtonsState();
}

class SearchOrderToggleButtonsState extends m.State<SearchOrderToggleButtons> {
  Map<pac.SearchOrder, bool> toggleButtonsSelection = {
    pac.SearchOrder.top: false,
    pac.SearchOrder.text: false,
    pac.SearchOrder.created: false,
    pac.SearchOrder.updated: false,
    pac.SearchOrder.popularity: false,
    pac.SearchOrder.like: false,
    pac.SearchOrder.points: false,
  };

  @override
  void initState() {
    super.initState();
    toggleButtonsSelection = updateSelection(widget.searchOrder);
  }

  Map<pac.SearchOrder, bool> updateSelection(pac.SearchOrder selection) =>
      toggleButtonsSelection.map(
        (key, value) => MapEntry(key, value = key == selection),
      );

  void onPressed(pac.SearchOrder order) {
    setState(() {
      toggleButtonsSelection = updateSelection(order);
    });
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  m.Widget build(m.BuildContext context) {
    return widget.isDialog
        ? DialogToggleButtons(
            toggleButtonsSelection: toggleButtonsSelection,
            textEditingControllerAdapter: widget.textEditingControllerAdapter,
            onPressed: onPressed,
          )
        : ToggleButtons(
            toggleButtonsSelection: toggleButtonsSelection,
            textEditingControllerAdapter: widget.textEditingControllerAdapter,
            onPressed: onPressed,
          );
  }
}
