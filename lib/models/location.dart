import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final String id;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  }) : id = '${latitude.toStringAsFixed(4)}${longitude.toStringAsFixed(4)}'; //4 decimali = precisione a 10m, due posizioni più vicine di 10m avranno lo stesso id -> verranno considerate come la stessa posizione

  @override
  List<Object> get props => [name, latitude, longitude, id];

  @override
  String toString() {
    return 'Location(name: $name, latitude: $latitude, longitude: $longitude, id: $id)';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'id': id,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }
}
