part of 'search_config_cubit.dart';

@meta.immutable
sealed class SearchConfigState {
  const SearchConfigState(this.config);

  final ps.ParsedSearchAdapter config;
}

@MappableClass()
final class SearchConfigInitial extends SearchConfigState
    with SearchConfigInitialMappable {
  const SearchConfigInitial(super.config);
}

@MappableClass()
final class SearchConfigChanged extends SearchConfigState
    with SearchConfigChangedMappable {
  const SearchConfigChanged(super.config);
}
