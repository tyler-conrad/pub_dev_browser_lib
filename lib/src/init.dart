import 'package:flutter/foundation.dart' as f;
import 'package:flutter/widgets.dart' as w;

import 'package:path_provider/path_provider.dart' as pp;
import 'package:hydrated_bloc/hydrated_bloc.dart' as hb;

/// Initializes the necessary components for the application.
///
/// This function ensures that the Flutter binding is initialized and sets up
/// the storage for the HydratedBloc. Depending on whether the application is
/// running on the web or not, it will use the appropriate storage directory.
Future<void> init() async {
  w.WidgetsFlutterBinding.ensureInitialized();
  hb.HydratedBloc.storage = await hb.HydratedStorage.build(
    storageDirectory: f.kIsWeb
        ? hb.HydratedStorage.webStorageDirectory
        : await pp.getTemporaryDirectory(),
  );
}
