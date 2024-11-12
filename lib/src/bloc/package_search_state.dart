part of 'package_search_bloc.dart';

@meta.immutable
sealed class PackageSearchState {
  const PackageSearchState();
}

@MappableClass()
final class PackageSearchInitial extends PackageSearchState
    with PackageSearchInitialMappable {}

@MappableClass()
final class PackageSearchLoading extends PackageSearchState
    with PackageSearchLoadingMappable {}

@MappableClass()
final class PackageSearchSuccess extends PackageSearchState
    with PackageSearchSuccessMappable {
  const PackageSearchSuccess(this.searchResults);

  final pac.SearchResults searchResults;
}
