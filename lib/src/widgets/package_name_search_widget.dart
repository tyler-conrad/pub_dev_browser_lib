import 'package:flutter/material.dart' as m;

import 'package:flutter_bloc/flutter_bloc.dart' as fb;
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fw;
import 'package:flutter_typeahead/flutter_typeahead.dart' as fta;

import '../common.dart' as c;
import '../logger.dart' as l;
import '../repo.dart' as repo;
import '../themed_text.dart' as tt;
import '../routes.dart' as r;
import '../bloc/load_package_names_bloc.dart' as lpnb;

/// Search field that uses the `flutter_typeahead` and `fuzzywuzzy` packages to
/// provide a dropdown list of package names that are similar to the user's
/// query.
///
/// Uses the [lpnb.LoadPackageNamesBloc] to fetch the package names from a
/// `HydratedBloc` which persists the names across app restarts and for period
/// of one hour between refreshes. The 10 most similar package names are shown
/// in the dropdown.
class PackageNameSearch extends m.StatelessWidget {
  const PackageNameSearch({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    final inputDecorationTheme = m.Theme.of(context).inputDecorationTheme;
    return fb.BlocProvider(
      create: (context) => lpnb.LoadPackageNamesBloc(context.read<repo.Repo>()),
      child:
          fb.BlocBuilder<lpnb.LoadPackageNamesBloc, lpnb.LoadPackageNamesState>(
        builder: (context, state) => fta.TypeAheadField<String>(
          hideOnLoading: true,
          suggestionsCallback: (search) => switch (state) {
            lpnb.LoadPackageNamesSuccess(:final packageNames) => fw
                .extractTop(
                  query: search,
                  choices: packageNames,
                  limit: 10,
                )
                .map((e) => e.choice)
                .toList(),
            lpnb.LoadPackageNamesInitial() => const <String>[],
            lpnb.LoadPackageNamesLoading() => const <String>[],
          },
          onSelected: (selection) {
            l.log.i('Selected: $selection');
            r.PackageRouteData(selection).push(context);
          },
          itemBuilder: (context, suggestion) => m.Padding(
            padding: const m.EdgeInsets.only(
              left: 40.0,
              top: c.itemPadding,
              bottom: c.itemPadding,
            ),
            child: tt.ThemedText.titleMedium()(suggestion),
          ),
          builder: (context, controller, focusNode) {
            return m.TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: null,
              decoration: m.InputDecoration(
                labelText: 'Search for a package by name',
                hintText: 'pub_api_client',
                prefixIcon: const m.Icon(m.Icons.search),
                focusedBorder: inputDecorationTheme.focusedBorder,
                enabledBorder: inputDecorationTheme.enabledBorder,
                errorBorder: inputDecorationTheme.errorBorder,
                disabledBorder: inputDecorationTheme.disabledBorder,
              ),
            );
          },
          decorationBuilder: (context, child) => child,
          transitionBuilder: (context, animation, child) => m.FadeTransition(
            opacity: m.CurvedAnimation(
                parent: animation, curve: m.Curves.fastOutSlowIn),
            child: child,
          ),
        ),
      ),
    );
  }
}
