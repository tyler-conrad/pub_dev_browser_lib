part of 'clear_cache_bloc.dart';

@meta.immutable
sealed class ClearCacheState {
  const ClearCacheState();
}

final class ClearCacheInitial extends ClearCacheState {}

final class ClearCacheCreated extends ClearCacheState {}

final class ClearCacheChecked extends ClearCacheState {
  const ClearCacheChecked(this.cleared);

  final bool cleared;
}
