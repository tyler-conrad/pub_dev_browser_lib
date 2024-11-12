import 'package:bloc/bloc.dart' as b;
import 'package:dart_mappable/dart_mappable.dart';
import 'package:meta/meta.dart' as meta;
import 'package:pub_api_client/pub_api_client.dart' as pac;

import '../repo.dart' as r;
import '../package_score.dart' as ps;

part 'generated/package_result_bloc.mapper.dart';
part 'package_result_event.dart';
part 'package_result_state.dart';

/// BloC to load the details of a package from pub.dev. Uses the [r.Repo]
/// methods `packageInfo` and `packageScore`.
///
/// Used by the `SearchResult` widget to display search results in a list on the
/// results screen.
class PackageResultBloc extends b.Bloc<PackageResultEvent, PackageResultState> {
  PackageResultBloc(r.Repo repo)
      : _repo = repo,
        super(const PackageResultInitial()) {
    on<PackageResultEvent>((event, emit) async {
      switch (event) {
        case PackageResultRequested(:final packageName):
          emit(const PackageResultLoading());
          emit(
            PackageResultSuccess(
              info: await _repo.packageInfo(packageName),
              score: await _repo.packageScore(packageName),
            ),
          );
          break;
      }
    });
  }

  final r.Repo _repo;
}
