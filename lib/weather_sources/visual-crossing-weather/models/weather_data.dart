import 'dart:convert';

import 'package:top_weather/weather_sources/visual-crossing-weather/models/alert.dart';
import 'package:top_weather/weather_sources/visual-crossing-weather/models/conditions.dart';

class WeatherData {
  double queryCost;
  double latitude;
  double longitude;
  String resolvedAddress;
  String address;
  String timezone;
  double tzoffset;
  String description;
  List<Conditions> days;
  List<Alert> alerts;
  Conditions currentConditions;

  WeatherData({
    required this.queryCost,
    required this.latitude,
    required this.longitude,
    required this.resolvedAddress,
    required this.address,
    required this.timezone,
    required this.tzoffset,
    required this.description,
    required this.days,
    required this.alerts,
    required this.currentConditions,
  });

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      queryCost: map['queryCost']?.toDouble() ?? 0.0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      resolvedAddress: map['resolvedAddress'] ?? '',
      address: map['address'] ?? '',
      timezone: map['timezone'] ?? '',
      tzoffset: map['tzoffset']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      days:
          List<Conditions>.from(map['days']?.map((x) => Conditions.fromMap(x))),
      alerts: List<Alert>.from(map['alerts']?.map((x) => Alert.fromMap(x))),
      currentConditions: Conditions.fromMap(map['currentConditions']),
    );
  }

  factory WeatherData.fromJson(String source) =>
      WeatherData.fromMap(json.decode(source));
}
