part of 'weather_location_bloc.dart';

abstract class WeatherLocationEvent extends Equatable {
  const WeatherLocationEvent();

  @override
  List<Object> get props => [];
}

class AddWeatherLocationEvent extends WeatherLocationEvent {
  final String name;
  const AddWeatherLocationEvent({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

class RemoveWeatherLocationEvent extends WeatherLocationEvent {
  final String id;
  const RemoveWeatherLocationEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
