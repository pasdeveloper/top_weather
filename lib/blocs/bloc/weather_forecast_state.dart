part of 'weather_forecast_bloc.dart';

class WeatherForecastState extends Equatable {
  final WeatherForecast? forecast;
  const WeatherForecastState({
    this.forecast,
  });

  WeatherForecastState copyWith({
    WeatherForecast? forecast,
  }) {
    return WeatherForecastState(
      forecast: forecast ?? this.forecast,
    );
  }

  @override
  String toString() => 'WeatherForecastState(forecast: $forecast)';

  @override
  List<Object?> get props => [forecast];
}
