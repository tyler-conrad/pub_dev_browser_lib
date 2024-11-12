import 'dart:async' as a;
import 'package:flutter/material.dart' as m;

import 'package:flutter_bloc/flutter_bloc.dart' as fb;

import '../common.dart' as c;
import '../logger.dart' as l;
import '../repo.dart' as repo;
import '../prefs_repo.dart' as pr;
import '../cubit/search_config_cubit.dart' as scc;
import '../bloc/clear_cache_bloc.dart' as ccb;
import '../routes.dart' as r;

/// [seedColor] used to generate the dark and light themes that are combined
/// into [customDarkColorScheme].
const seedColor = m.Color.fromARGB(255, 118, 163, 186);

/// [darkColorScheme] used as a base for the [customDarkColorScheme].
final darkColorScheme = m.ColorScheme.fromSeed(
  brightness: m.Brightness.dark,
  seedColor: seedColor,
  dynamicSchemeVariant: m.DynamicSchemeVariant.content,
);

/// [lightColorScheme] used as a base for the [customDarkColorScheme].
final lightColorScheme = m.ColorScheme.fromSeed(
  brightness: m.Brightness.light,
  seedColor: seedColor,
  dynamicSchemeVariant: m.DynamicSchemeVariant.content,
  onPrimary: darkColorScheme.onPrimary,
);

/// [customDarkColorScheme] uses colors from both [darkColorScheme] and
/// [lightColorScheme] to create a custom dark theme.
final customDarkColorScheme = lightColorScheme.copyWith(
  onPrimary: darkColorScheme.onPrimary,
  primaryContainer: const m.Color.fromARGB(255, 118, 163, 186),
  onPrimaryContainer: darkColorScheme.onPrimaryContainer,
  onSecondary: darkColorScheme.onSecondary,
  onTertiary: darkColorScheme.onTertiary,
  onTertiaryContainer: darkColorScheme.onTertiaryContainer,
  error: darkColorScheme.error,
  onError: darkColorScheme.onError,
  errorContainer: darkColorScheme.errorContainer,
  onErrorContainer: darkColorScheme.onErrorContainer,
  surfaceDim: darkColorScheme.surfaceDim,
  surface: darkColorScheme.surface,
  surfaceBright: darkColorScheme.surfaceBright,
  surfaceContainerLowest: darkColorScheme.surfaceContainerLowest,
  surfaceContainerLow: darkColorScheme.surfaceContainerLow,
  surfaceContainer: darkColorScheme.surfaceContainer,
  surfaceContainerHigh: darkColorScheme.surfaceContainerHigh,
  surfaceContainerHighest: darkColorScheme.surfaceContainerHighest,
  onSurface: darkColorScheme.onSurface,
  onSurfaceVariant: darkColorScheme.onSurfaceVariant,
  onInverseSurface: darkColorScheme.onInverseSurface,
  inversePrimary: darkColorScheme.inversePrimary,
);

/// Base widget for the application.
///
/// Builds the `customTheme` for styling the apps widgets and inserts the
/// `RepositoryProviders` and `SearchConfigCubit` BlocProvider into the widget
/// tree.
class Browser extends m.StatelessWidget {
  const Browser({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    final theme = m.Theme.of(context);

    final customTheme = m.ThemeData(
      colorScheme: customDarkColorScheme,
      splashFactory: m.NoSplash.splashFactory,
      splashColor: m.Colors.transparent,
      appBarTheme: m.AppBarTheme.of(context).copyWith(
        backgroundColor: customDarkColorScheme.primary,
        foregroundColor: customDarkColorScheme.onPrimary,
      ),
      navigationRailTheme: m.NavigationRailTheme.of(context).copyWith(
        indicatorColor: customDarkColorScheme.onPrimary,
        selectedIconTheme: m.IconThemeData(
          color: customDarkColorScheme.primaryFixed,
        ),
        selectedLabelTextStyle: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        unselectedIconTheme: m.IconThemeData(
          color: customDarkColorScheme.outline,
        ),
        unselectedLabelTextStyle: m.TextStyle(
          color: customDarkColorScheme.outline,
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.merge(
        m.InputDecorationTheme(
          prefixIconColor: m.WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(m.WidgetState.disabled)) {
                return customDarkColorScheme.secondary;
              } else if (states.contains(m.WidgetState.focused)) {
                return customDarkColorScheme.primary;
              } else if (states.contains(m.WidgetState.error)) {
                return customDarkColorScheme.error;
              } else if (states.contains(m.WidgetState.hovered)) {
                return customDarkColorScheme.secondary;
              } else if (states.contains(m.WidgetState.selected)) {
                return customDarkColorScheme.primary;
              } else {
                return customDarkColorScheme.secondary;
              }
            },
          ),
          labelStyle: m.TextStyle(
            color: customDarkColorScheme.secondary,
          ),
          floatingLabelStyle: m.TextStyle(
            color: customDarkColorScheme.primary,
          ),
          hintStyle: m.TextStyle(
            color: customDarkColorScheme.secondary,
          ),
          focusedBorder: m.OutlineInputBorder(
            borderSide: m.BorderSide(
              color: customDarkColorScheme.primary,
            ),
          ),
          enabledBorder: m.OutlineInputBorder(
            borderSide: m.BorderSide(
              color: customDarkColorScheme.secondary,
            ),
          ),
          errorBorder: m.OutlineInputBorder(
            borderSide: m.BorderSide(
              color: customDarkColorScheme.error,
            ),
          ),
          focusedErrorBorder: m.OutlineInputBorder(
            borderSide: m.BorderSide(
              color: customDarkColorScheme.error,
            ),
          ),
          disabledBorder: m.OutlineInputBorder(
            borderSide: m.BorderSide(
              color: customDarkColorScheme.secondary,
            ),
          ),
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        displayLarge: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        displayMedium: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        displaySmall: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        headlineMedium: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        headlineSmall: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        titleLarge: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        titleMedium: m.TextStyle(
          color: customDarkColorScheme.primaryContainer,
        ),
        titleSmall: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        bodyLarge: m.TextStyle(
          color: customDarkColorScheme.primaryContainer,
        ),
        bodyMedium: m.TextStyle(
          color: customDarkColorScheme.primaryContainer,
        ),
        bodySmall: m.TextStyle(
          color: customDarkColorScheme.primaryContainer,
          fontWeight: m.FontWeight.bold,
        ),
        labelLarge: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
        labelSmall: m.TextStyle(
          color: customDarkColorScheme.primary,
        ),
      ),
      cardTheme: m.CardTheme.of(context).copyWith(
        color: customDarkColorScheme.primary,
      ),
      outlinedButtonTheme: m.OutlinedButtonThemeData(
        style: m.ButtonStyle(
          backgroundColor: m.WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(m.WidgetState.disabled)) {
                return customDarkColorScheme.secondary;
              } else if (states.contains(m.WidgetState.hovered)) {
                return customDarkColorScheme.primary;
              } else {
                return customDarkColorScheme.onPrimary;
              }
            },
          ),
          side: m.WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(m.WidgetState.disabled)) {
                return m.BorderSide(
                  color: customDarkColorScheme.onSecondary,
                );
              } else if (states.contains(m.WidgetState.hovered)) {
                return m.BorderSide(
                  color: customDarkColorScheme.secondaryFixed,
                );
              } else {
                return m.BorderSide(
                  color: customDarkColorScheme.primaryContainer,
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
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: customDarkColorScheme.primaryContainer,
        thickness: 1.0,
      ),
    );

    return fb.MultiRepositoryProvider(
      providers: [
        fb.RepositoryProvider(
          create: (_) => const pr.PrefsRepo(),
        ),
        fb.RepositoryProvider(
          create: (_) => repo.Repo(),
        ),
      ],
      child: fb.MultiBlocProvider(
        providers: [
          fb.BlocProvider(
            create: (context) => ccb.ClearCacheBloc(
              context.read<pr.PrefsRepo>(),
            ),
          ),
          fb.BlocProvider(
            create: (_) => scc.SearchConfigCubit(),
          ),
        ],
        child: App(theme: customTheme),
      ),
    );
  }
}

/// Used to manage a cache of package names so that the "Search by package name"
/// search bar can be re-populated once an hour.
///
/// Caching the result of the of the network request `packageNames()` helps to
/// prevent slow loading times when the user searches by package name.  The
/// state of the cache is maintained by using the `SharedPreferences` package.
/// The cached date itself is persisted by using a `HydratedBloc`.
///
/// The `build()` method of this widget creates a `MaterialApp` through the
/// `router()` factory constructor which allows for the use of GoRouter to
/// provide type-safe routing.
class App extends m.StatefulWidget {
  const App({super.key, required this.theme});

  final m.ThemeData theme;

  @override
  AppState createState() => AppState();
}

class AppState extends m.State<App> {
  @override
  void initState() {
    super.initState();
    context.read<ccb.ClearCacheBloc>().add(ccb.CheckClearCache());
    a.Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        context.read<ccb.ClearCacheBloc>().add(ccb.CheckClearCache());
      } else {
        l.log.e('Browser widget is not mounted');
      }
    });
  }

  @override
  m.Widget build(m.BuildContext context) {
    return fb.BlocListener<ccb.ClearCacheBloc, ccb.ClearCacheState>(
      listener: (context, state) {
        switch (state) {
          case ccb.ClearCacheInitial():
            break;
          case ccb.ClearCacheCreated():
            l.log.i('Cache clear SharedPreferences created');
            break;
          case ccb.ClearCacheChecked(:final cleared):
            if (cleared) {
              l.log.i('Cache cleared');
            } else {
              l.log.i('Cache retained');
            }
            break;
        }
      },
      child: m.MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: widget.theme,
        darkTheme: widget.theme,
        themeMode: m.ThemeMode.dark,
        routerConfig: r.goRouter,
      ),
    );
  }
}
