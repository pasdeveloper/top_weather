part of 'weather_location_bloc.dart';

enum WeatherLocationStatus {
  loading,
  complete,
  error;

  String toMap() => name;
  static WeatherLocationStatus fromMap(String name) => values.byName(name);
}

class WeatherLocationState extends Equatable {
  final List<WeatherLocation> locations;
  final WeatherLocationStatus status;
  final String error;
  const WeatherLocationState({
    required this.locations,
    required this.status,
    required this.error,
  });

  factory WeatherLocationState.initial() => const WeatherLocationState(
      locations: [], status: WeatherLocationStatus.complete, error: '');

  @override
  List<Object> get props => [locations, status, error];

  WeatherLocationState copyWith({
    List<WeatherLocation>? locations,
    WeatherLocationStatus? status,
    String? error,
  }) {
    return WeatherLocationState(
      locations: locations ?? this.locations,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'WeatherLocationState(locations: $locations, status: $status, error: $error)';
  }

  Map<String, dynamic> toMap() {
    return {
      'locations': locations.map((x) => x.toMap()).toList(),
      'status': status.toMap(),
      'error': error,
    };
  }

  factory WeatherLocationState.fromMap(Map<String, dynamic> map) {
    return WeatherLocationState(
      locations: List<WeatherLocation>.from(
          map['locations']?.map((x) => WeatherLocation.fromMap(x))),
      status: WeatherLocationStatus.fromMap(map['status']),
      error: map['error'] ?? '',
    );
  }
}
