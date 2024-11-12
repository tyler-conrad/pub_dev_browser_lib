import 'package:flutter/widgets.dart' as w;

import 'package:pub_api_client/pub_api_client.dart' as pac;
import 'parsed_search.dart' as ps;

/// Adapter for the [w.TextEditingController] class.
///
/// Provides methods to add and remove tags from the [w.TextEditingController].
class TextEditingControllerAdapter {
  static final whitespaceRegExp = RegExp(r'^\s$');

  final w.TextEditingController controller;

  TextEditingControllerAdapter(this.controller);

  // Add a new tag if it doesn't already exist in the controller's text.
  void addTags(List<String> tags) {
    if (tags.isEmpty) {
      return;
    }

    var newTags = tags
        .where(
          (tag) => !(controller.text.contains(tag)),
        )
        .join(' ');

    controller.value = w.TextEditingValue(
        text: controller.text +
            (whitespaceRegExp.hasMatch(
              controller.text.isEmpty
                  ? ' '
                  : controller.text[controller.text.length - 1],
            )
                ? '$newTags '
                : ' $newTags '));
  }

  // Remove a tag and it's corresponding whitespace from the controller's text.
  void removeTags(List<String> tags) {
    String text = controller.text;
    for (final tag in tags) {
      text = text.replaceAll(RegExp('$tag\\s*'), '');
    }
    controller.value = w.TextEditingValue(text: text);
  }

  // Set the contoller's text from a [ps.ParsedSearchAdapter]. Used by the
  // `SearchResultsScreenWidget` to display the search query.
  void textFromParsedSearchAdapter(ps.ParsedSearchAdapter adapter) {
    controller.value = w.TextEditingValue(
        text: [
      switch (adapter.searchOrder()) {
        pac.SearchOrder.top => 'sort:top',
        pac.SearchOrder.text => 'sort:text',
        pac.SearchOrder.created => 'sort:created',
        pac.SearchOrder.updated => 'sort:updated',
        pac.SearchOrder.popularity => 'sort:popularity',
        pac.SearchOrder.like => 'sort:likes',
        pac.SearchOrder.points => 'sort:points',
      },
      ...[
        adapter.sdks(),
        adapter.platforms(),
        adapter.isA(),
        adapter.has(),
        adapter.licenses(),
        adapter.dependencies(),
        adapter.show(),
        adapter.topicTags(),
      ].expand((tag) => tag),
      adapter.publisher(),
      adapter.query(),
    ].join(' '));
  }
}
