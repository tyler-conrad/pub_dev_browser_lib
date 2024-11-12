import 'package:dart_mappable/dart_mappable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart' as hb;
import 'package:meta/meta.dart' as meta;

import '../repo.dart' as repo;

part 'generated/load_package_names_bloc.mapper.dart';
part 'load_package_names_event.dart';
part 'load_package_names_state.dart';

/// Uses a hydrated BloC to store the names of all packaged on pub.dev which is
/// refreshed once an hour.
class LoadPackageNamesBloc
    extends hb.HydratedBloc<LoadPackageNamesEvent, LoadPackageNamesState> {
  LoadPackageNamesBloc(repo.Repo repo)
      : _repo = repo,
        super(LoadPackageNamesInitial()) {
    on<LoadPackageNamesEvent>((event, emit) async {
      emit(LoadPackageNamesLoading());
      emit(
        LoadPackageNamesSuccess(
          await _repo.packageNames(),
        ),
      );
    });
    add(const LoadPackageNamesRequested());
  }

  final repo.Repo _repo;

  @override
  LoadPackageNamesState fromJson(Map<String, dynamic> json) {
    return LoadPackageNamesState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(LoadPackageNamesState state) {
    return state.toMap();
  }
}
