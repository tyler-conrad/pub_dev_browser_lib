import 'package:dart_mappable/dart_mappable.dart';
import 'package:bloc/bloc.dart' as b;
import 'package:meta/meta.dart' as meta;
import 'package:pub_api_client/pub_api_client.dart' as pac;

import '../repo.dart' as repo;
import '../parsed_search.dart' as ps;

part 'generated/package_search_bloc.mapper.dart';
part 'package_search_event.dart';
part 'package_search_state.dart';

/// BloC to search for packages on pub.dev. Uses the [repo.Repo] method
/// `search`.
///
/// Used by the `SearchResultsScreen` widget.
class PackageSearchBloc extends b.Bloc<PackageSearchEvent, PackageSearchState> {
  PackageSearchBloc(repo.Repo repo)
      : _repo = repo,
        super(PackageSearchInitial()) {
    on<PackageSearchEvent>((PackageSearchEvent event, emit) async {
      switch (event) {
        case PackageSearchRequested(:final parsedSearchAdapter, :final page):
          emit(PackageSearchLoading());
          emit(
            PackageSearchSuccess(
              await _repo.pubClient.search(
                parsedSearchAdapter.query(),
                sort: parsedSearchAdapter.searchOrder(),
                tags: parsedSearchAdapter.tags(),
                topics: parsedSearchAdapter.topics(),
                page: page,
              ),
            ),
          );
          break;
      }
    });
  }
  final repo.Repo _repo;
}
