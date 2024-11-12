import 'package:flutter/material.dart' as m;

import 'package:pub_api_client/pub_api_client.dart' as pac;
import 'package:flutter_bloc/flutter_bloc.dart' as fb;

import '../common.dart' as c;
import '../repo.dart' as repo;
import '../themed_text.dart' as tt;
import '../parsed_search.dart' as ps;
import '../cubit/search_config_cubit.dart' as scc;
import '../bloc/package_search_bloc.dart' as psb;
import 'search_result_widget.dart' as srw;
import 'search_order_toggle_button_widget.dart';
import '../search_field_text_editing_controller.dart' as sftec;
import '../text_editing_controller_adapter.dart' as teca;
import 'package_search_widget.dart' as psw;
import 'segmented_buttons_widget.dart' as sb;
import 'selectable_outlined_button_widget.dart' as sob;
import '../search_parser.dart' as sp;
import '../routes.dart' as r;

const double segmentedButtonInnerPadding = 8.0;

/// Dialog that is displayed when the user taps on a search filter button.
///
/// The dialog displays a list of selectable buttons that represent search
/// filters that are mutually exclusive.
class SearchFilterDialog extends m.StatelessWidget {
  const SearchFilterDialog({super.key, required this.child});

  final m.Widget child;

  @override
  m.Widget build(m.BuildContext context) {
    return m.AlertDialog(
      shape: m.RoundedRectangleBorder(
        borderRadius: const m.BorderRadius.all(
          m.Radius.circular(
            c.borderRadius * 4.0,
          ),
        ),
        side: m.BorderSide(
          color: m.Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      actions: [
        m.OutlinedButton(
          onPressed: () {
            m.Navigator.of(context, rootNavigator: true).pop();
          },
          child: tt.ThemedText.bodySmall()('Ok'),
        ),
      ],
      content: child,
    );
  }
}

/// A button that represents a search filter.
class SearchFilterButton extends m.StatelessWidget {
  const SearchFilterButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final m.VoidCallback onPressed;

  @override
  m.Widget build(m.BuildContext context) {
    return c.Tappable(
      onPressed: onPressed,
      child: tt.ThemedText.titleMedium()(label),
    );
  }
}

/// [RegExp] that matches a sort filter.
///
/// Used to build labels for sort buttons.
final sortsRegExp = RegExp(
  r'sort:(top|text|created|updated|popularity|likes|points)',
);

/// Base widget for the search results screen that displays the search results.
///
/// The widget displays the search results and allows the user progressively
/// build a search query by using tags and search filters and clicking on
/// elements of a search result. Allows navigation to the next or previous page
/// of results.
class SearchResultsScreenWidget extends m.StatefulWidget {
  const SearchResultsScreenWidget({
    super.key,
    required this.parsedSearchAdapter,
    required this.page,
  });

  final ps.ParsedSearchAdapter parsedSearchAdapter;
  final int page;

  @override
  m.State<SearchResultsScreenWidget> createState() =>
      SearchResultsScreenWidgetState();
}

class SearchResultsScreenWidgetState
    extends m.State<SearchResultsScreenWidget> {
  static const double iconButtonIconSize = 64.0;

  final teca.TextEditingControllerAdapter textEditingControllerAdapter =
      teca.TextEditingControllerAdapter(
    sftec.SearchFieldTextEditingController(),
  );

  String sortLabel = '';

  sob.SelectableOutlinedButton selectableOutlinedButton({
    required String label,
    required List<String> tags,
    required RegExp regExp,
    required teca.TextEditingControllerAdapter textEditingControllerAdapter,
  }) =>
      sob.selectableOutlinedButton(
        label: label,
        tags: tags,
        regExp: regExp,
        textEditingControllerAdapter: textEditingControllerAdapter,
      );

  String buildSortLabel(teca.TextEditingControllerAdapter adapter) =>
      'Sort: ${switch (sortsRegExp.firstMatch(adapter.controller.text.split(c.whitespaceRegExp).firstWhere(
            (e) => sortsRegExp.hasMatch(e),
            orElse: () => '',
          ))?.group(1) ?? '') {
        'top' => 'Top',
        'text' => 'Text',
        'created' => 'Created',
        'updated' => 'Updated',
        'popularity' => 'Popularity',
        'likes' => 'Likes',
        'points' => 'Points',
        _ => 'None',
      }}';

  @override
  void initState() {
    super.initState();
    textEditingControllerAdapter.textFromParsedSearchAdapter(
      widget.parsedSearchAdapter,
    );
    Future.delayed(Duration.zero, () {
      setState(() {
        sortLabel = buildSortLabel(textEditingControllerAdapter);
      });
    });
  }

  @override
  void dispose() {
    textEditingControllerAdapter.controller.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    return fb.BlocProvider(
      create: (context) => psb.PackageSearchBloc(context.read<repo.Repo>())
        ..add(psb.PackageSearchRequested(
          widget.parsedSearchAdapter,
          widget.page,
        )),
      child: fb.BlocBuilder<psb.PackageSearchBloc, psb.PackageSearchState>(
        builder: (context, state) => switch (state) {
          psb.PackageSearchInitial() => const m.Center(
              child: m.CircularProgressIndicator(),
            ),
          psb.PackageSearchLoading() => const m.Center(
              child: m.CircularProgressIndicator(),
            ),
          psb.PackageSearchSuccess(:final searchResults) => m.Column(
              children: [
                m.Padding(
                  padding: const m.EdgeInsets.only(
                    left: c.horizontalInset,
                    top: c.itemPadding * 2.0,
                    right: c.horizontalInset,
                  ),
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    children: [
                      psw.PackageSearchWidget(
                        textEditingControllerAdapter:
                            textEditingControllerAdapter,
                      ),
                      const m.SizedBox(height: c.itemPadding * 2.0),
                      m.Row(
                        children: [
                          sb.SegmentedButtons(
                            innerPadding: segmentedButtonInnerPadding,
                            children: [
                              (
                                label: 'Platforms',
                                onPressed: () {
                                  m.showDialog(
                                    context: context,
                                    builder: (_) {
                                      return SearchFilterDialog(
                                        child: m.Column(
                                          mainAxisSize: m.MainAxisSize.min,
                                          children: [
                                            selectableOutlinedButton(
                                              label: 'Android',
                                              tags: [
                                                pac.PackageTag.platformAndroid,
                                              ],
                                              regExp:
                                                  RegExp(r'^platform:android$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'iOS',
                                              tags: [
                                                pac.PackageTag.platformIos,
                                              ],
                                              regExp: RegExp(r'^platform:ios$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Linux',
                                              tags: [
                                                pac.PackageTag.platformLinux,
                                              ],
                                              regExp:
                                                  RegExp(r'^platform:linux$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'macOS',
                                              tags: [
                                                pac.PackageTag.platformMacos,
                                              ],
                                              regExp:
                                                  RegExp(r'^platform:macos$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Windows',
                                              tags: [
                                                pac.PackageTag.platformWindows,
                                              ],
                                              regExp:
                                                  RegExp(r'^platform:windows$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Web',
                                              tags: [
                                                pac.PackageTag.platformWeb,
                                              ],
                                              regExp: RegExp(r'^platform:web$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              ),
                              (
                                label: 'SDKs',
                                onPressed: () {
                                  m.showDialog(
                                    context: context,
                                    builder: (_) {
                                      return SearchFilterDialog(
                                        child: m.Column(
                                          mainAxisSize: m.MainAxisSize.min,
                                          children: [
                                            selectableOutlinedButton(
                                              label: 'Dart',
                                              tags: [
                                                pac.PackageTag.sdkDart,
                                              ],
                                              regExp: RegExp(r'^sdk:dart$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Flutter',
                                              tags: [
                                                pac.PackageTag.sdkFlutter,
                                              ],
                                              regExp: RegExp(r'^sdk:flutter$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              ),
                              (
                                label: 'License',
                                onPressed: () {
                                  m.showDialog(
                                    context: context,
                                    builder: (_) {
                                      return SearchFilterDialog(
                                        child: m.Column(
                                          mainAxisSize: m.MainAxisSize.min,
                                          children: [
                                            selectableOutlinedButton(
                                              label: 'License OSI Approved',
                                              tags: [
                                                pac.PackageTag
                                                    .licenseOsiApproved,
                                              ],
                                              regExp: RegExp(
                                                r'^license:osi-approved$',
                                              ),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              ),
                              (
                                label: 'Advanced',
                                onPressed: () {
                                  m.showDialog(
                                    context: context,
                                    builder: (_) {
                                      return SearchFilterDialog(
                                        child: m.Column(
                                          mainAxisSize: m.MainAxisSize.min,
                                          children: [
                                            selectableOutlinedButton(
                                              label: 'Flutter Favorite',
                                              tags: [
                                                pac.PackageTag.isFlutterFavorite
                                              ],
                                              regExp: RegExp(
                                                r'^is:flutter-favorite$',
                                              ),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Include Unlisted',
                                              tags: [
                                                pac.PackageTag.showUnlisted,
                                              ],
                                              regExp:
                                                  RegExp(r'^show:unlisted$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Has Screenshot',
                                              tags: [
                                                pac.PackageTag.hasScreenshot,
                                              ],
                                              regExp:
                                                  RegExp(r'^has:screenshot$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Dart 3 Ready',
                                              tags: const [
                                                'is:dart3-compatible'
                                              ],
                                              regExp: RegExp(
                                                  r'^is:dart3-compatible$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Plugin',
                                              tags: const ['is:plugin'],
                                              regExp: RegExp(r'^is:plugin$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'WASM Ready',
                                              tags: const ['is:wasm-ready'],
                                              regExp:
                                                  RegExp(r'^is:wasm-ready$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                            selectableOutlinedButton(
                                              label: 'Null Safe',
                                              tags: const ['is:null-safe'],
                                              regExp: RegExp(r'^is:null-safe$'),
                                              textEditingControllerAdapter:
                                                  textEditingControllerAdapter,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              ),
                            ]
                                .map<m.Widget>(
                                  (config) => SearchFilterButton(
                                    label: config.label,
                                    onPressed: config.onPressed,
                                  ),
                                )
                                .toList(),
                          ),
                          const m.Expanded(child: m.SizedBox.shrink()),
                          sb.SegmentedButtons(
                            innerPadding: segmentedButtonInnerPadding,
                            children: [
                              c.Tappable(
                                child: tt.ThemedText.titleMedium()(sortLabel),
                                onPressed: () async {
                                  await m.showDialog(
                                    context: context,
                                    builder: (_) {
                                      return SearchFilterDialog(
                                        child: SearchOrderToggleButtons(
                                          textEditingControllerAdapter:
                                              textEditingControllerAdapter,
                                          searchOrder: ps.ParsedSearchAdapter(
                                            sp.SearchParser(
                                              textEditingControllerAdapter
                                                  .controller.text,
                                            ).parse(),
                                          ).searchOrder(),
                                          isDialog: true,
                                        ),
                                      );
                                    },
                                  );
                                  if (mounted) {
                                    context
                                        .read<scc.SearchConfigCubit>()
                                        .setConfig(
                                          ps.ParsedSearchAdapter(
                                            sp.SearchParser(
                                              textEditingControllerAdapter
                                                  .controller.text,
                                            ).parse(),
                                          ),
                                        );
                                  }
                                  setState(() {
                                    sortLabel = buildSortLabel(
                                      textEditingControllerAdapter,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const m.SizedBox(height: c.itemPadding * 2.0),
                    ],
                  ),
                ),
                m.Expanded(
                  child: m.ListView.builder(
                    itemCount: searchResults.packages.length,
                    itemBuilder: (context, index) => srw.SearchResult(
                      packageName: searchResults.packages[index].package,
                      textEditingControllerAdapter:
                          textEditingControllerAdapter,
                    ),
                  ),
                ),
                m.Row(children: [
                  if (widget.page > 1)
                    m.IconButton(
                      icon: m.Icon(
                        m.Icons.chevron_left,
                        color: colorScheme.primaryContainer,
                        size: iconButtonIconSize,
                      ),
                      onPressed: () {
                        r.PackageSearchResultsRouteData(
                          page: widget.page - 1,
                          query: widget.parsedSearchAdapter.query(),
                          sort: widget.parsedSearchAdapter.searchOrder(),
                          tags: widget.parsedSearchAdapter.tags(),
                          topics: widget.parsedSearchAdapter.topics(),
                        ).push(context);
                      },
                    ),
                  m.Expanded(
                    child: m.Center(
                      child: tt.ThemedText.headlineSmall(
                          style: m.TextStyle(
                        color: colorScheme.primary,
                      ))('Page ${widget.page}'),
                    ),
                  ),
                  m.IconButton(
                    icon: m.Icon(
                      m.Icons.chevron_right,
                      color: colorScheme.primaryContainer,
                      size: iconButtonIconSize,
                    ),
                    onPressed: () {
                      r.PackageSearchResultsRouteData(
                        page: widget.page + 1,
                        query: widget.parsedSearchAdapter.query(),
                        sort: widget.parsedSearchAdapter.searchOrder(),
                        tags: widget.parsedSearchAdapter.tags(),
                        topics: widget.parsedSearchAdapter.topics(),
                      ).push(context);
                    },
                  ),
                ])
              ],
            ),
        },
      ),
    );
  }
}
