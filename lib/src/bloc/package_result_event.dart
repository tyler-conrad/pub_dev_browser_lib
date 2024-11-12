part of 'package_result_bloc.dart';

@meta.immutable
sealed class PackageResultEvent {
  const PackageResultEvent();
}

@MappableClass()
final class PackageResultRequested extends PackageResultEvent
    with PackageResultRequestedMappable {
  const PackageResultRequested(this.packageName);

  final String packageName;
}
