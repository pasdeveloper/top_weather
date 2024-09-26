import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/models/weather_location.dart';
import 'package:top_weather/repository/weather_repository.dart';

part 'weather_forecast_event.dart';
part 'weather_forecast_state.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final WeatherRepository weatherRepository;
  WeatherForecastBloc({required this.weatherRepository})
      : super(WeatherForecastState.initial()) {
    on<GetLocationForecastEvent>(_getLocationForecast);
  }

  void _getLocationForecast(GetLocationForecastEvent event,
      Emitter<WeatherForecastState> emit) async {
    emit(state.copyWith(status: WeatherForecastStatus.loading));

    final forecast = await weatherRepository
        .getWeatherForecastByLocationName(event.location.name);

    emit(state.copyWith(
      forecast: forecast,
      status: WeatherForecastStatus.complete,
    ));
  }
}
