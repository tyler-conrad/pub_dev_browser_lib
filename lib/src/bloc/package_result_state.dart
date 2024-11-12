part of 'package_result_bloc.dart';

@meta.immutable
sealed class PackageResultState {
  const PackageResultState();
}

@MappableClass()
final class PackageResultInitial extends PackageResultState
    with PackageResultInitialMappable {
  const PackageResultInitial();
}

@MappableClass()
final class PackageResultLoading extends PackageResultState
    with PackageResultLoadingMappable {
  const PackageResultLoading();
}

@MappableClass()
final class PackageResultSuccess extends PackageResultState
    with PackageResultSuccessMappable {
  const PackageResultSuccess({required this.info, required this.score});

  final pac.PubPackage info;
  final ps.PackageScore score;

  @override
  String toString() => 'PackageInfoSuccess()';
}
