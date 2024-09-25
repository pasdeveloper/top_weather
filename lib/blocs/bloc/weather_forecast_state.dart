part of 'weather_forecast_bloc.dart';

class WeatherForecastState extends Equatable {
  final WeatherForecast forecast;
  final WeatherForecastStatus status;
  const WeatherForecastState({
    required this.forecast,
    required this.status,
  });

  WeatherForecastState copyWith({
    WeatherForecast? forecast,
    WeatherForecastStatus? status,
  }) {
    return WeatherForecastState(
      forecast: forecast ?? this.forecast,
      status: status ?? this.status,
    );
  }

  factory WeatherForecastState.initial() {
    return WeatherForecastState(
      forecast: WeatherForecast.empty(),
      status: WeatherForecastStatus.empty,
    );
  }

  @override
  String toString() => 'WeatherForecastState(forecast: $forecast)';

  @override
  List<Object> get props => [forecast, status];
}
