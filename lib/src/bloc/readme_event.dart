part of 'readme_bloc.dart';

@meta.immutable
sealed class ReadmeEvent {
  const ReadmeEvent();
}

@MappableClass()
final class ReadmeRequested extends ReadmeEvent with ReadmeRequestedMappable {
  const ReadmeRequested({required this.owner, required this.name});

  final String owner;
  final String name;
}
