import 'package:bloc/bloc.dart' as b;
import 'package:dart_mappable/dart_mappable.dart';
import 'package:meta/meta.dart' as meta;
import 'package:pub_api_client/pub_api_client.dart' as pac;

import '../repo.dart' as r;

part 'generated/package_details_bloc.mapper.dart';
part 'package_details_event.dart';
part 'package_details_state.dart';

/// BloC to load the details of a package from pub.dev. Uses the [r.Repo]
/// methods `packageInfo` and `packageMetrics`.
///
/// Used by the package details screen widget.
class PackageDetailsBloc
    extends b.Bloc<PackageDetailsEvent, PackageDetailsState> {
  PackageDetailsBloc(this._repo) : super(const PackageDetailsInitial()) {
    on<PackageDetailsEvent>((event, emit) async {
      switch (event) {
        case PackageDetailsRequested(:final packageName):
          emit(const PackageDetailsLoading());
          emit(
            PackageDetailsSuccess(
              info: await _repo.packageInfo(packageName),
              metrics: await _repo.packageMetrics(packageName),
            ),
          );
          break;
      }
    });
  }

  final r.Repo _repo;
}
