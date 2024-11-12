part of 'package_details_bloc.dart';

@meta.immutable
sealed class PackageDetailsEvent {
  const PackageDetailsEvent();
}

@MappableClass()
final class PackageDetailsRequested extends PackageDetailsEvent
    with PackageDetailsRequestedMappable {
  const PackageDetailsRequested(this.packageName);

  final String packageName;
}
