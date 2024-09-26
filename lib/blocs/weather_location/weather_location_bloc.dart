import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:top_weather/models/weather_location.dart';
import 'package:top_weather/repository/weather_repository.dart';

part 'weather_location_event.dart';
part 'weather_location_state.dart';

class WeatherLocationBloc
    extends HydratedBloc<WeatherLocationEvent, WeatherLocationState> {
  final WeatherRepository weatherRepository;
  WeatherLocationBloc({required this.weatherRepository})
      : super(WeatherLocationState.initial()) {
    on<AddWeatherLocationEvent>((event, emit) async {
      emit(state.copyWith(status: WeatherLocationStatus.loading));
      try {
        final searchedLocation =
            await weatherRepository.searchWeatherLocation(name: event.name);

        if (searchedLocation == null) {
          emit(state.copyWith(
              status: WeatherLocationStatus.error,
              error: 'Location ${event.name} not found.'));
          return;
        }

        final newLocations = List.of(state.locations);
        if (newLocations
            .any((location) => location.id == searchedLocation.id)) {
          emit(state.copyWith(
              status: WeatherLocationStatus.error,
              error: 'Location ${event.name} already added.'));
          return;
        }
        newLocations.insert(0, searchedLocation);
        emit(state.copyWith(
          locations: newLocations,
          status: WeatherLocationStatus.complete,
        ));
      } catch (e) {
        emit(state.copyWith(
            status: WeatherLocationStatus.error, error: e.toString()));
      }
    });

    on<RemoveWeatherLocationEvent>((event, emit) {
      final newLocations = state.locations
          .where(
            (location) => location.id != event.id,
          )
          .toList();
      emit(state.copyWith(
          locations: newLocations, status: WeatherLocationStatus.complete));
    });
  }

  @override
  WeatherLocationState? fromJson(Map<String, dynamic> json) {
    final WeatherLocationState state = WeatherLocationState.fromMap(json);
    return state;
  }

  @override
  Map<String, dynamic>? toJson(WeatherLocationState state) {
    final map = state.toMap();
    return map;
  }
}
