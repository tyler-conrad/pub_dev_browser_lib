import 'package:bloc/bloc.dart' as b;
import 'package:meta/meta.dart' as meta;
import 'package:shared_preferences/shared_preferences.dart' as sp;

import '../prefs_repo.dart' as pr;

part 'clear_cache_event.dart';
part 'clear_cache_state.dart';

/// BLoC for clearing the cache.
///
/// The BLoC checks if the cache should be cleared and clears it if necessary.
/// As the application is configured this recaches the names of all packages
/// once per hour across application restarts. Whether to clear the cache is
/// is maintained using the `shared_preferences` package. And the cache itself
/// is stored in the `hydrated_bloc` storage.
class ClearCacheBloc extends b.Bloc<ClearCacheEvent, ClearCacheState> {
  ClearCacheBloc(this._prefsRepo)
      : _prefs = _prefsRepo.create(),
        super(ClearCacheInitial()) {
    on<ClearCacheEvent>((event, emit) async {
      switch (event) {
        case CheckClearCache():
          emit(ClearCacheChecked(
              await _prefsRepo.checkClearCache(await _prefs)));
          break;
      }
    });
  }

  final pr.PrefsRepo _prefsRepo;
  final Future<sp.SharedPreferencesWithCache> _prefs;
}
