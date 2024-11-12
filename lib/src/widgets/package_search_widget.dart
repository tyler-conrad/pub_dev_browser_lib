import 'package:flutter/material.dart' as m;

import 'package:flutter_bloc/flutter_bloc.dart' as fb;

import '../common.dart' as c;
import '../themed_text.dart' as tt;
import '../cubit/search_config_cubit.dart' as scc;
import '../parsed_search.dart' as ps;
import '../search_parser.dart' as sp;
import '../text_editing_controller_adapter.dart' as teca;
import '../routes.dart' as r;

/// A search widget that allows the user to enter a search query and then
/// navigate to the search results page.
///
/// The search query is parsed using the `SearchParser` and the parsed search
/// is then passed to the `SearchConfigCubit` to persist the query between
/// screens.  This allows for a query to be progressively built up as the user
/// navigates through the search results.
class PackageSearchWidget extends m.StatefulWidget {
  const PackageSearchWidget({
    super.key,
    required this.textEditingControllerAdapter,
  });

  final teca.TextEditingControllerAdapter textEditingControllerAdapter;

  @override
  m.State<PackageSearchWidget> createState() => PackageSearchWidgetState();
}

class PackageSearchWidgetState extends m.State<PackageSearchWidget> {
  String? errorText;
  bool searchButtonHovered = false;

  late final m.FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    // support submitting the text field search query by pressing enter
    focusNode = c.onEnterSubmitFocusNode(() {
      final parsedSearch = parseSearch();
      if (parsedSearch != null) {
        final adapter = ps.ParsedSearchAdapter(parsedSearch);
        r.PackageSearchResultsRouteData(
                page: 1,
                query: adapter.query(),
                sort: adapter.searchOrder(),
                tags: adapter.tags(),
                topics: adapter.topics())
            .push(context);
      }
    });
  }

  ps.ParsedSearch? parseSearch() {
    ps.ParsedSearch? parsedSearch;
    bool hasError = false;
    try {
      parsedSearch =
          sp.SearchParser(widget.textEditingControllerAdapter.controller.text)
              .parse();
    } on sp.InvalidPlatformException catch (e) {
      hasError = true;
      setState(() {
        errorText = 'Invalid platform: ${e.platformTag}';
      });
    } on sp.InvalidSdkTagException catch (e) {
      hasError = true;
      setState(() {
        errorText =
            'Invalid SDK tag: ${e.sdkTag}, must be either flutter or dart';
      });
    } on sp.InvalidSortSpecifierException catch (e) {
      hasError = true;
      setState(() {
        errorText = 'Invalid sort specifier: ${e.sortSpecifier}';
      });
    } on sp.InvalidNumberOfSortsException catch (e) {
      hasError = true;
      setState(() {
        errorText =
            'A single sort must be provided, ${e.sorts.isEmpty ? 'no sorts specified' : 'sorts: ${e.sorts.join(', ')}'}';
      });
    }
    if (!hasError) {
      setState(() {
        errorText = null;
      });
    }
    return parsedSearch;
  }

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    return m.Row(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: <m.Widget>[
        m.Expanded(
          flex: 4,
          child: m.Padding(
            padding: const m.EdgeInsets.only(right: 16.0),
            child: m.TextField(
              controller: widget.textEditingControllerAdapter.controller,
              focusNode: focusNode,
              maxLines: null,
              decoration: m.InputDecoration(
                labelText: 'Search for a package',
                hintText: 'image viewer',
                errorText: errorText,
                prefixIcon: const m.Icon(m.Icons.search),
              ),
            ),
          ),
        ),
        m.Flexible(
          flex: 1,
          child: m.MouseRegion(
            onEnter: (_) {
              setState(() {
                searchButtonHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                searchButtonHovered = false;
              });
            },
            child: m.OutlinedButton(
              onPressed: () {
                final parsedSearch = parseSearch();
                if (parsedSearch != null) {
                  final adapter = ps.ParsedSearchAdapter(parsedSearch);
                  context.read<scc.SearchConfigCubit>().setConfig(adapter);
                  r.PackageSearchResultsRouteData(
                          page: 1,
                          query: adapter.query(),
                          sort: adapter.searchOrder(),
                          tags: adapter.tags(),
                          topics: adapter.topics())
                      .push(context);
                }
              },
              child: m.SizedBox(
                height: 48.0,
                child: m.Center(
                  child: tt.ThemedText.titleMedium(
                    style: m.TextStyle(
                      color: searchButtonHovered
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.primaryContainer,
                    ),
                  )('Search'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
