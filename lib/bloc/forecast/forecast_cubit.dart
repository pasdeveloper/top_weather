import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/repository/weather_repository.dart';

part 'forecast_state.dart';

class ForecastCubit extends Cubit<ForecastState> {
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
}
