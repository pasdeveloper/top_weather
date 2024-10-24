import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/repository/weather_repository.dart';

part 'locations_state.dart';

class LocationsCubit extends HydratedCubit<LocationsState> {
  final WeatherRepository _repository;
  LocationsCubit(this._repository) : super(LocationsState.initial());

  Future<Location?> searchAndAddLocation(String locationName) async {
    emit(state.copyWith(status: LocationsStatus.loading));

    Location? newLocation;
    try {
      newLocation = await _repository.searchWeatherLocation(locationName);

      if (newLocation == null) {
        emit(state.copyWith(
            status: LocationsStatus.error,
            error: 'Location $locationName not found.'));
        return null;
      }

      final locations = List.of(state.locations);
      if (locations.any((location) => location.id == newLocation!.id)) {
        emit(state.copyWith(
            status: LocationsStatus.error,
            error: 'Location $locationName already added.'));
        return null;
      }

      locations.insert(0, newLocation);
      emit(state.copyWith(status: LocationsStatus.ok, locations: locations));
    } catch (e) {
      emit(state.copyWith(status: LocationsStatus.error, error: e.toString()));
    }
    return newLocation;
  }

  void removeLocation(Location toRemove) {
    final locations = List.of(state.locations)..remove(toRemove);
    emit(state.copyWith(locations: locations));
  }

  void errorDeliveredToUser() {
    emit(state.copyWith(status: LocationsStatus.ok));
  }

  @override
  LocationsState? fromJson(Map<String, dynamic> json) {
    final state = LocationsState.fromMap(json);
    return state;
  }

  @override
  Map<String, dynamic>? toJson(LocationsState state) {
    final map = state.toMap();
    return map;
  }
}
