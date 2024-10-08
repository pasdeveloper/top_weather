import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:top_weather/models/forecast/forecast.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/repository/weather_repository.dart';

part 'forecast_state.dart';

// hydrated so that on first laucnh doesn't show empty weather
class ForecastCubit extends HydratedCubit<ForecastState> {
  final WeatherRepository _repository;
  ForecastCubit(this._repository) : super(ForecastState.initial());

  void fetchForecast(Location location) async {
    emit(state.copyWith(status: ForecastStatus.loading));

    try {
      final forecast = await _repository.fetchWeatherForecast(location);
      emit(state.copyWith(status: ForecastStatus.ok, forecast: forecast));
    } catch (e) {
      emit(state.copyWith(status: ForecastStatus.error, error: e.toString()));
    }
  }

  void emptyForecast() {
    emit(state.copyWith(
        status: ForecastStatus.empty, forecast: Forecast.empty()));
  }

  @override
  ForecastState? fromJson(Map<String, dynamic> json) {
    final state = ForecastState.fromMap(json);
    return state;
  }

  @override
  Map<String, dynamic>? toJson(ForecastState state) {
    final map = state.toMap();
    return map;
  }
}
