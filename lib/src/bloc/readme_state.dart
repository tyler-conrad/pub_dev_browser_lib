part of 'readme_bloc.dart';

@meta.immutable
sealed class ReadmeState {
  const ReadmeState();
}

@MappableClass()
final class ReadmeInitial extends ReadmeState with ReadmeInitialMappable {}

@MappableClass()
final class ReadmeLoading extends ReadmeState with ReadmeLoadingMappable {}

@MappableClass()
final class ReadmeSuccess extends ReadmeState with ReadmeSuccessMappable {
  const ReadmeSuccess(this.data);

  final String data;
}
