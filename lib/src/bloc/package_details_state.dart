part of 'package_details_bloc.dart';

@meta.immutable
sealed class PackageDetailsState {
  const PackageDetailsState();
}

@MappableClass()
final class PackageDetailsInitial extends PackageDetailsState
    with PackageDetailsInitialMappable {
  const PackageDetailsInitial();
}

@MappableClass()
final class PackageDetailsLoading extends PackageDetailsState
    with PackageDetailsLoadingMappable {
  const PackageDetailsLoading();
}

@MappableClass()
final class PackageDetailsSuccess extends PackageDetailsState
    with PackageDetailsSuccessMappable {
  const PackageDetailsSuccess({required this.info, required this.metrics});

  final pac.PubPackage info;
  final pac.PackageMetrics? metrics;

  @override
  String toString() => 'PackageInfoSuccess()';
}
