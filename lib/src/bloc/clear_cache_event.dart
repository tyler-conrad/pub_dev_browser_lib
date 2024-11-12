part of 'clear_cache_bloc.dart';

@meta.immutable
sealed class ClearCacheEvent {}

final class CheckClearCache extends ClearCacheEvent {}
