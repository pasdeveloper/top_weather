import 'package:equatable/equatable.dart';
import 'package:top_weather/models/forecast/forecast_icon.dart';
import 'package:top_weather/models/forecast/hourly_forecast.dart';

class DailyForecast extends Equatable {
  final List<DayForecast> days;

  const DailyForecast({
    required this.days,
  });

  @override
  List<Object> get props => [days];

  @override
  String toString() => 'DailyForecast(days: $days)';

  Map<String, dynamic> toMap() {
    return {
      'days': days.map((x) => x.toMap()).toList(),
    };
  }

  factory DailyForecast.fromMap(Map<String, dynamic> map) {
    return DailyForecast(
      days: List<DayForecast>.from(
          map['days']?.map((x) => DayForecast.fromMap(x))),
    );
  }
}

class DayForecast extends Equatable {
  final DateTime datetime;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final ForecastIcon icon;
  final int? precipitationProbability;
  final HourlyForecast? hourlyForecast;

  const DayForecast({
    required this.datetime,
    required this.minTemperature,
    required this.maxTemperature,
    required this.icon,
    required this.description,
    this.precipitationProbability,
    this.hourlyForecast,
  });

  @override
  List<Object?> get props {
    return [
      datetime,
      minTemperature,
      maxTemperature,
      description,
      icon,
      precipitationProbability,
      hourlyForecast,
    ];
  }

  @override
  String toString() {
    return 'DayForecast(datetime: $datetime, minTemperature: $minTemperature, maxTemperature: $maxTemperature, description: $description, icon: $icon, precipitationProbability: $precipitationProbability, hourlyForecast: $hourlyForecast)';
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime.millisecondsSinceEpoch,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'description': description,
      'icon': icon.toMap(),
      'precipitationProbability': precipitationProbability,
      'hourlyForecast': hourlyForecast?.toMap(),
    };
  }

  factory DayForecast.fromMap(Map<String, dynamic> map) {
    return DayForecast(
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
      minTemperature: map['minTemperature']?.toDouble() ?? 0.0,
      maxTemperature: map['maxTemperature']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      icon: ForecastIcon.fromMap(map['icon']),
      precipitationProbability: map['precipitationProbability']?.toInt(),
      hourlyForecast: map['hourlyForecast'] != null
          ? HourlyForecast.fromMap(map['hourlyForecast'])
          : null,
    );
  }
}
