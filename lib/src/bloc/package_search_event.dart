part of 'package_search_bloc.dart';

@meta.immutable
sealed class PackageSearchEvent {
  const PackageSearchEvent();
}

@MappableClass()
class PackageSearchRequested extends PackageSearchEvent
    with PackageSearchRequestedMappable {
  const PackageSearchRequested(this.parsedSearchAdapter, this.page);

  final ps.ParsedSearchAdapter parsedSearchAdapter;
  final int page;
}
