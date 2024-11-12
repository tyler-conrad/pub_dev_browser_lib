import 'package:hydrated_bloc/hydrated_bloc.dart' as hb;
import 'package:shared_preferences/shared_preferences.dart' as sp;

/// Repository for the shared preferences.
///
/// This repository is responsible for creating the shared preferences instance.
/// It also provides a method to check if the cache should be cleared depending
/// on the last time it was cleared.  The clearing of the cache happens in one
/// hour intervals.
class PrefsRepo {
  const PrefsRepo();

  Future<sp.SharedPreferencesWithCache> create() async {
    return sp.SharedPreferencesWithCache.create(
      cacheOptions: const sp.SharedPreferencesWithCacheOptions(
        allowList: <String>{'lastCleared'},
      ),
    );
  }

  Future<bool> checkClearCache(sp.SharedPreferencesWithCache prefs) async {
    int? lastCleared = prefs.getInt('lastCleared');
    if (lastCleared == null) {
      hb.HydratedBloc.storage.clear();
      await prefs.setInt(
          'lastCleared', DateTime.now().toUtc().millisecondsSinceEpoch);
      return true;
    } else if (DateTime.now().toUtc().millisecondsSinceEpoch - lastCleared >
        60 * 60 * 1000) {
      hb.HydratedBloc.storage.clear();
      await prefs.setInt(
          'lastCleared', DateTime.now().toUtc().millisecondsSinceEpoch);
      return true;
    }
    return false;
  }
}
