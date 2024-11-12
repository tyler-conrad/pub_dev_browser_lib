part of 'load_package_names_bloc.dart';

@meta.immutable
sealed class LoadPackageNamesEvent {
  const LoadPackageNamesEvent();
}

@MappableClass()
final class LoadPackageNamesRequested extends LoadPackageNamesEvent
    with LoadPackageNamesRequestedMappable {
  const LoadPackageNamesRequested();
}
