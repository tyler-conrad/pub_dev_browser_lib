import 'package:bloc/bloc.dart' as b;
import 'package:dart_mappable/dart_mappable.dart';
import 'package:meta/meta.dart' as meta;
import 'package:github/github.dart' as gh;

import '../repo.dart' as r;

part 'generated/readme_bloc.mapper.dart';
part 'readme_event.dart';
part 'readme_state.dart';

/// BloC to get the README of a GitHub repository. Uses the [r.Repo] method
/// `getReadme`.
///
/// Used by the package details screen widget.
class ReadmeBloc extends b.Bloc<ReadmeEvent, ReadmeState> {
  ReadmeBloc(this._repo) : super(ReadmeInitial()) {
    on<ReadmeEvent>((event, emit) async {
      switch (event) {
        case ReadmeRequested(:final owner, :final name):
          emit(ReadmeLoading());
          emit(ReadmeSuccess((await _repo.githubClient.repositories
                  .getReadme(gh.RepositorySlug(owner, name)))
              .text));
      }
    });
  }

  final r.Repo _repo;
}
