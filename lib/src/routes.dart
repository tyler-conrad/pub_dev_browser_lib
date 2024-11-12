import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_api_client/pub_api_client.dart';

import 'logger.dart' as l;
import 'cubit/search_config_cubit.dart' as scc;
import 'widgets/scaffold_widget.dart' as scaffold;
import 'widgets/splash_screen_widget.dart' as splash;
import 'widgets/search_screen_widget.dart' as search;
import 'parsed_search.dart' as ps;
import 'widgets/search_results_screen_widget.dart' as search_results;
import 'widgets/package_screen_widget.dart' as package;

part 'routes.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Typed splash screen route.
@TypedGoRoute<SplashScreenRouteData>(path: '/')
class SplashScreenRouteData extends GoRouteData {
  const SplashScreenRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const splash.SplashScreen();
  }
}

/// Type shell route that contains a [scaffold.Scaffold] that wraps all contents
/// for the sub-routes: [SearchRouteData], [PackageSearchResultsRouteData], and
/// [PackageRouteData].
@TypedShellRoute<ScaffoldShellRouteData>(routes: <TypedRoute<RouteData>>[
  TypedGoRoute<SearchRouteData>(path: '/search'),
  TypedGoRoute<PackageSearchResultsRouteData>(path: '/search/results/:page'),
  TypedGoRoute<PackageRouteData>(path: '/package/:packageName'),
])
class ScaffoldShellRouteData extends ShellRouteData {
  const ScaffoldShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) =>
      scaffold.Scaffold(child: navigator);
}

class SearchRouteData extends GoRouteData {
  const SearchRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    l.log.i(GoRouter.of(context).routeInformationProvider.value.uri);
    return search.SearchScreen(
      parsedSearchAdapter: context.read<scc.SearchConfigCubit>().state.config,
    );
  }
}

/// Typed package search results route.
class PackageSearchResultsRouteData extends GoRouteData {
  const PackageSearchResultsRouteData({
    required this.page,
    required this.query,
    required this.sort,
    required this.tags,
    required this.topics,
  });

  final int page;
  final String query;
  final SearchOrder sort;
  final List<String>? tags;
  final List<String>? topics;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    l.log.i(GoRouter.of(context).routeInformationProvider.value.uri);
    return search_results.SearchResultsScreenWidget(
      parsedSearchAdapter: ps.ParsedSearchAdapter(
        ps.ParsedSearch(
          query: query,
          sort: sort,
          tags: tags ?? [],
          topics: topics ?? [],
        ),
      ),
      page: page,
    );
  }
}

/// Typed package details route.
class PackageRouteData extends GoRouteData {
  const PackageRouteData(this.packageName);

  final String packageName;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    l.log.i(GoRouter.of(context).routeInformationProvider.value.uri);
    return package.PackageScreen(packageName: packageName);
  }
}

final goRouter = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
);
