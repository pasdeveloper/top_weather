part of 'weather_forecast_bloc.dart';

abstract class WeatherForecastEvent extends Equatable {
  const WeatherForecastEvent();

  @override
  List<Object> get props => [];
}

class GetLatLonForecastEvent extends WeatherForecastEvent {
  final double latitude;
  final double longitude;
  const GetLatLonForecastEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() =>
      'GetLatLonForecastEvent(latitude: $latitude, longitude: $longitude)';

  @override
  List<Object> get props => [latitude, longitude];
}
