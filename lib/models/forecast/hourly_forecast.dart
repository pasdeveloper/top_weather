import 'package:equatable/equatable.dart';
import 'package:top_weather/models/forecast/forecast_icon.dart';

class HourlyForecast extends Equatable {
  final List<HourForecast> hours;

  const HourlyForecast({
    required this.hours,
  });

  @override
  List<Object> get props => [hours];

  @override
  String toString() => 'HourlyForecast(hours: $hours)';

  Map<String, dynamic> toMap() {
    return {
      'hours': hours.map((x) => x.toMap()).toList(),
    };
  }

  factory HourlyForecast.fromMap(Map<String, dynamic> map) {
    return HourlyForecast(
      hours: List<HourForecast>.from(
          map['hours']?.map((x) => HourForecast.fromMap(x))),
    );
  }
}

class HourForecast extends Equatable {
  final DateTime datetime;
  final double temperature;
  final ForecastIcon icon;
  final String description;
  final int? precipitationProbability;

  int get temperatureRound => temperature.round();

  const HourForecast({
    required this.datetime,
    required this.temperature,
    required this.icon,
    required this.description,
    this.precipitationProbability,
  });

  @override
  List<Object?> get props {
    return [
      datetime,
      temperature,
      icon,
      description,
      precipitationProbability,
    ];
  }

  @override
  String toString() {
    return 'HourForecast(datetime: $datetime, temperature: $temperature, icon: $icon, description: $description, precipitationProbability: $precipitationProbability)';
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime.millisecondsSinceEpoch,
      'temperature': temperature,
      'icon': icon.toMap(),
      'description': description,
      'precipitationProbability': precipitationProbability,
    };
  }

  factory HourForecast.fromMap(Map<String, dynamic> map) {
    return HourForecast(
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
      temperature: map['temperature']?.toDouble() ?? 0.0,
      icon: ForecastIcon.fromMap(map['icon']),
      description: map['description'] ?? '',
      precipitationProbability: map['precipitationProbability']?.toInt(),
    );
  }
}
