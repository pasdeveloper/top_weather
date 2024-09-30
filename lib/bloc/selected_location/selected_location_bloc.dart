import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:top_weather/models/location.dart';

part 'selected_location_event.dart';
part 'selected_location_state.dart';

class SelectedLocationBloc
    extends HydratedBloc<SelectedLocationEvent, SelectedLocationState> {
  SelectedLocationBloc() : super(SelectedLocationState.initial()) {
    on<UpdateSelectedLocationEvent>((event, emit) {
      emit(state.copyWith(selectedLocation: event.toSelect));
    });
    on<ClearSelectedLocationEvent>((event, emit) {
      emit(SelectedLocationState.initial());
    });
    on<TriggerListenerEvent>((event, emit) {
      emit(state.copyWith(triggerListener: !state.triggerListener));
    });
  }

  @override
  SelectedLocationState? fromJson(Map<String, dynamic> json) {
    final state = SelectedLocationState.fromMap(json);
    return state;
  }

  @override
  Map<String, dynamic>? toJson(SelectedLocationState state) {
    final map = state.toMap();
    return map;
  }
}
