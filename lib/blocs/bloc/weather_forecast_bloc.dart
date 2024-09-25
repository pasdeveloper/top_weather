import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/repository/weather_repository.dart';

part 'weather_forecast_event.dart';
part 'weather_forecast_state.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final WeatherRepository weatherService;
  WeatherForecastBloc({required this.weatherService})
      : super(const WeatherForecastState()) {
    on<GetLatLonForecastEvent>(_getLanLonForecast);
  }

  void _getLanLonForecast(
      GetLatLonForecastEvent event, Emitter<WeatherForecastState> emit) async {
    final forecast = await weatherService.getWeatherForecast(
        latitude: event.latitude, longitude: event.longitude);
    emit(state.copyWith(forecast: forecast));
  }
}
