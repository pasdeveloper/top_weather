import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:top_weather/constants/assets.dart';
import 'package:top_weather/models/forecast/daily_forecast.dart';
import 'package:top_weather/models/forecast/forecast_icon.dart';
import 'package:top_weather/models/forecast/hourly_forecast.dart';

final _random = Random();
const _hotIfMoreThan = 30;
const _coldIfLessThan = 5;
const _isNightUntil = 5;
const _isNightAfter = 21;
const _snowIfMoreThan = 0;
const _rainIfMoreThan = 30; // % precipitation probability
const _windIfMoreThan = 20; // km/h
const _fogIfLessThan = 2; // km visibility
const _cloudIfMoreThan = 50; // % cloud coverage

// ignore: must_be_immutable
class Forecast extends Equatable {
  final String currentLocation;
  final ForecastIcon icon;
  final String description;
  final double nowTemperature;
  final double todayMinTemperature;
  final double todayMaxTemperature;
  final double feelsLikeTemperature;
  final String weatherSource;
  final DateTime weatherDataDatetime;
  final DateTime createdAt;
  final HourlyForecast? hourlyForecast;
  final DailyForecast? dailyForecast;
  final double windSpeed;
  final double windDirection;
  final double pressure;
  final double uvIndex;
  final double? snow;
  final double? precipitationProbability;
  final double? visibility;
  final double? cloudCoverPercentage;
  final DateTime? sunrise;
  final DateTime? sunset;
  late bool _empty = false;
  bool get empty => _empty;

  int get nowTemperatureRound => nowTemperature.round();
  int get todayMinTemperatureRound => todayMinTemperature.round();
  int get todayMaxTemperatureRound => todayMaxTemperature.round();
  int get feelsLikeTemperatureRound => feelsLikeTemperature.round();

  late String _background;
  String get background => _background;

  Forecast({
    required this.currentLocation,
    required this.icon,
    required this.description,
    required this.nowTemperature,
    required this.todayMinTemperature,
    required this.todayMaxTemperature,
    required this.feelsLikeTemperature,
    required this.weatherSource,
    required this.weatherDataDatetime, // datetime in requested location zone
    this.hourlyForecast,
    this.dailyForecast,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.uvIndex,
    required this.snow,
    required this.precipitationProbability,
    required this.visibility,
    required this.cloudCoverPercentage,
    this.sunrise,
    this.sunset,
  }) : createdAt = DateTime.now() {
    _setBackground();
  }

  factory Forecast.empty() => Forecast(
        currentLocation: '',
        icon: ForecastIcon.notAvailable,
        description: '',
        nowTemperature: 0,
        todayMinTemperature: 0,
        todayMaxTemperature: 0,
        feelsLikeTemperature: 0,
        weatherSource: '',
        sunrise: DateTime(2001, 7, 4),
        sunset: DateTime(2001, 7, 4),
        weatherDataDatetime: DateTime(2001, 7, 4),
        windSpeed: 0,
        windDirection: 0,
        pressure: 0,
        uvIndex: 0,
        snow: null,
        precipitationProbability: null,
        visibility: null,
        cloudCoverPercentage: null,
      )
        .._empty = true
        .._setBackground();

  void _setBackground() => _background = _getAppropriateForecastBackground();

  String _getAppropriateForecastBackground() {
    if (empty) return Assets.weatherBackgroundDayCloudyHouseMorning;

    bool isNight = weatherDataDatetime.hour >= _isNightAfter ||
        weatherDataDatetime.hour < _isNightUntil;
    bool isHot = nowTemperature > _hotIfMoreThan;
    bool isCold = nowTemperature < _coldIfLessThan;

    if (snow != null && snow! > _snowIfMoreThan) {
      return isNight
          ? Assets.weatherBackgroundNightSnowyMountainNight
          : Assets.weatherBackgroundDaySnowyColdMountain;
    }

    if (precipitationProbability != null &&
        precipitationProbability! > _rainIfMoreThan) {
      return isNight
          ? Assets.weatherBackgroundNightLightning
          : _randomBetween([
              Assets.weatherBackgroundDayRainyMountain,
              Assets.weatherBackgroundDayRainyTrain
            ]);
    }

    if (visibility != null && visibility! < _fogIfLessThan) {
      return isNight
          ? Assets.weatherBackgroundNightFoggyNight
          : isHot
              ? Assets.weatherBackgroundDayFoggyHotHills
              : isCold
                  ? Assets.weatherBackgroundDayFoggyHills
                  : Assets.weatherBackgroundDayFoggySeaMorning;
    }

    if (windSpeed > _windIfMoreThan) {
      return isNight
          ? Assets.weatherBackgroundNightWindyNight
          : Assets.weatherBackgroundDayWindy;
    }

    if (cloudCoverPercentage != null &&
        cloudCoverPercentage! > _cloudIfMoreThan) {
      return isNight
          ? Assets.weatherBackgroundNightCloudyHouseNight
          : isCold
              ? Assets.weatherBackgroundDayCloudyColdHills
              : Assets.weatherBackgroundDayCloudyHouseMorning;
    }

    return isNight
        ? isHot
            ? Assets.weatherBackgroundNightHotDesertNight
            : Assets.weatherBackgroundNightClearStarsNight
        : isHot
            ? Assets.weatherBackgroundDayClearHotDesert
            : _randomBetween([
                Assets.weatherBackgroundDayClear,
                Assets.weatherBackgroundDayClearRainbowMorning,
                Assets.weatherBackgroundDayClearHills
              ]);
  }

  String _randomBetween(List<String> options) {
    final randomIndex = _random.nextInt(options.length);
    return options[randomIndex];
  }

  @override
  String toString() {
    return 'Forecast(currentLocation: $currentLocation, icon: $icon, description: $description, nowTemperature: $nowTemperature, todayMinTemperature: $todayMinTemperature, todayMaxTemperature: $todayMaxTemperature, feelsLikeTemperature: $feelsLikeTemperature, weatherSource: $weatherSource, weatherDataDatetime: $weatherDataDatetime, createdAt: $createdAt, hourlyForecast: $hourlyForecast, dailyForecast: $dailyForecast, windSpeed: $windSpeed, windDirection: $windDirection, pressure: $pressure, uvIndex: $uvIndex, snow: $snow, precipitationProbability: $precipitationProbability, visibility: $visibility, cloudCoverPercentage: $cloudCoverPercentage, sunrise: $sunrise, sunset: $sunset, _empty: $_empty, _background: $_background)';
  }

  @override
  List<Object?> get props {
    return [
      currentLocation,
      icon,
      description,
      nowTemperature,
      todayMinTemperature,
      todayMaxTemperature,
      feelsLikeTemperature,
      weatherSource,
      weatherDataDatetime,
      createdAt,
      hourlyForecast,
      dailyForecast,
      windSpeed,
      windDirection,
      pressure,
      uvIndex,
      snow,
      precipitationProbability,
      visibility,
      cloudCoverPercentage,
      sunrise,
      sunset,
      _empty,
      _background,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'currentLocation': currentLocation,
      'icon': icon.toMap(),
      'description': description,
      'nowTemperature': nowTemperature,
      'todayMinTemperature': todayMinTemperature,
      'todayMaxTemperature': todayMaxTemperature,
      'feelsLikeTemperature': feelsLikeTemperature,
      'weatherSource': weatherSource,
      'weatherDataDatetime': weatherDataDatetime.millisecondsSinceEpoch,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
      'hourlyForecast': hourlyForecast?.toMap(),
      'dailyForecast': dailyForecast?.toMap(),
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'pressure': pressure,
      'uvIndex': uvIndex,
      'snow': snow,
      'precipitationProbability': precipitationProbability,
      'visibility': visibility,
      'cloudCoverPercentage': cloudCoverPercentage,
      'sunrise': sunrise?.millisecondsSinceEpoch,
      'sunset': sunset?.millisecondsSinceEpoch,
    };
  }

  factory Forecast.fromMap(Map<String, dynamic> map) {
    return Forecast(
      currentLocation: map['currentLocation'] ?? '',
      icon: ForecastIcon.fromMap(map['icon']),
      description: map['description'] ?? '',
      nowTemperature: map['nowTemperature']?.toDouble() ?? 0.0,
      todayMinTemperature: map['todayMinTemperature']?.toDouble() ?? 0.0,
      todayMaxTemperature: map['todayMaxTemperature']?.toDouble() ?? 0.0,
      feelsLikeTemperature: map['feelsLikeTemperature']?.toDouble() ?? 0.0,
      weatherSource: map['weatherSource'] ?? '',
      weatherDataDatetime:
          DateTime.fromMillisecondsSinceEpoch(map['weatherDataDatetime']),
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      hourlyForecast: map['hourlyForecast'] != null
          ? HourlyForecast.fromMap(map['hourlyForecast'])
          : null,
      dailyForecast: map['dailyForecast'] != null
          ? DailyForecast.fromMap(map['dailyForecast'])
          : null,
      windSpeed: map['windSpeed']?.toDouble() ?? 0.0,
      windDirection: map['windDirection']?.toDouble() ?? 0.0,
      pressure: map['pressure']?.toDouble() ?? 0.0,
      uvIndex: map['uvIndex']?.toDouble() ?? 0.0,
      snow: map['snow']?.toDouble(),
      precipitationProbability: map['precipitationProbability']?.toDouble(),
      visibility: map['visibility']?.toDouble(),
      cloudCoverPercentage: map['cloudCoverPercentage']?.toDouble(),
      sunrise: map['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sunrise'])
          : null,
      sunset: map['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sunset'])
          : null,
    );
  }
}
