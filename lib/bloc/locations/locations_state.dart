part of 'locations_cubit.dart';

enum LocationsStatus {
  loading,
  ok,
  error;

  String toMap() => name;
  static LocationsStatus fromMap(String name) => values.byName(name);
}

class LocationsState extends Equatable {
  final List<Location> locations;
  final LocationsStatus status;
  final String error;

  const LocationsState({
    required this.locations,
    required this.status,
    this.error = '',
  });

  factory LocationsState.initial() {
    return const LocationsState(locations: [], status: LocationsStatus.ok);
  }

  @override
  List<Object> get props => [locations, status, error];

  @override
  String toString() =>
      'LocationsState(locations: $locations, status: $status, error: $error)';

  LocationsState copyWith({
    List<Location>? locations,
    LocationsStatus? status,
    String? error,
  }) {
    return LocationsState(
      locations: locations ?? this.locations,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locations': locations.map((x) => x.toMap()).toList(),
      'status': status.toMap(),
      'error': error,
    };
  }

  factory LocationsState.fromMap(Map<String, dynamic> map) {
    return LocationsState(
      locations: List<Location>.from(
          map['locations']?.map((x) => Location.fromMap(x))),
      status: LocationsStatus.fromMap(map['status']),
      error: map['error'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationsState.fromJson(String source) =>
      LocationsState.fromMap(json.decode(source));
}
