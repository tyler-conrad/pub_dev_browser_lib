import 'package:flutter/material.dart' as m;

import '../common.dart' as c;
import '../parsed_search.dart' as ps;
import 'tags_selector_widget.dart' as ts;
import '../search_field_text_editing_controller.dart' as sftec;
import '../text_editing_controller_adapter.dart' as teca;
import 'labeled_divider_widget.dart' as ld;
import 'search_order_toggle_button_widget.dart' as stb;
import 'package_search_widget.dart' as psw;
import 'package_name_search_widget.dart' as pns;

/// Base widget for the search screen that displays the search tags, sort order,
/// and search fields.
///
/// Allows searching for packages by using a query and tags or fuzzy searching
/// by package name. Contiains widgets for selecting tags and sorting search
/// results by different criteria.
class SearchScreen extends m.StatefulWidget {
  const SearchScreen({super.key, required this.parsedSearchAdapter});

  final ps.ParsedSearchAdapter parsedSearchAdapter;

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends m.State<SearchScreen> {
  teca.TextEditingControllerAdapter textEditingControllerAdapter =
      teca.TextEditingControllerAdapter(
    sftec.SearchFieldTextEditingController(),
  );

  @override
  void dispose() {
    textEditingControllerAdapter.controller.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Padding(
      padding: const m.EdgeInsets.only(
        left: c.horizontalInset,
        right: c.horizontalInset,
      ),
      child: m.Column(
        children: <m.Widget>[
          const ld.LabeledDivider(label: 'Tags'),
          ts.TagSelector(
            textEditingControllerAdapter: textEditingControllerAdapter,
          ),
          const ld.LabeledDivider(label: 'Sort'),
          stb.SearchOrderToggleButtons(
            textEditingControllerAdapter: textEditingControllerAdapter,
            searchOrder: widget.parsedSearchAdapter.searchOrder(),
            isDialog: false,
          ),
          const ld.LabeledDivider(label: 'Search'),
          psw.PackageSearchWidget(
              textEditingControllerAdapter: textEditingControllerAdapter),
          const ld.LabeledDivider(label: 'Search By Package Name'),
          const pns.PackageNameSearch(),
        ],
      ),
    );
  }
}
