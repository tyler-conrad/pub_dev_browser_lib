part of 'load_package_names_bloc.dart';

@meta.immutable
@MappableClass()
sealed class LoadPackageNamesState with LoadPackageNamesStateMappable {
  const LoadPackageNamesState();
  static const fromMap = LoadPackageNamesStateMapper.fromMap;
}

@MappableClass()
final class LoadPackageNamesInitial extends LoadPackageNamesState
    with LoadPackageNamesInitialMappable {
  static const fromMap = LoadPackageNamesInitialMapper.fromMap;
}

@MappableClass()
final class LoadPackageNamesLoading extends LoadPackageNamesState
    with LoadPackageNamesLoadingMappable {
  static const fromMap = LoadPackageNamesLoadingMapper.fromMap;
}

@MappableClass()
final class LoadPackageNamesSuccess extends LoadPackageNamesState
    with LoadPackageNamesSuccessMappable {
  const LoadPackageNamesSuccess(this.packageNames);

  final List<String> packageNames;

  static const fromMap = LoadPackageNamesSuccessMapper.fromMap;

  @override
  String toString() => 'LoadPackageNamesSuccess()';
}
