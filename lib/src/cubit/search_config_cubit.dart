import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:meta/meta.dart' as meta;

import '../parsed_search.dart' as ps;

part 'generated/search_config_cubit.mapper.dart';
part 'search_config_state.dart';

/// Cubit to manage the search configuration.
///
/// This allows maintaining the search configuration across different screens
/// when popping or navigating to a new route.
class SearchConfigCubit extends Cubit<SearchConfigState> {
  SearchConfigCubit()
      : super(
          SearchConfigInitial(
            ps.ParsedSearchAdapter(
              const ps.ParsedSearch(),
            ),
          ),
        );

  void setConfig(ps.ParsedSearchAdapter config) {
    emit(SearchConfigChanged(config));
  }
}
