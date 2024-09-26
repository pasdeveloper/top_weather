part of 'weather_forecast_bloc.dart';

abstract class WeatherForecastEvent extends Equatable {
  const WeatherForecastEvent();

  @override
  List<Object> get props => [];
}

class GetLocationForecastEvent extends WeatherForecastEvent {
  final WeatherLocation location;
  const GetLocationForecastEvent({
    required this.location,
  });

  @override
  String toString() => 'GetLocationForecastEvent(location: $location)';

  @override
  List<Object> get props => [location];
}
