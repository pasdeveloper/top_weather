import 'dart:math';

import 'package:top_weather/constants/assets.dart';

final _random = Random();
const _hotIfMoreThan = 30;
const _coldIfLessThan = 5;
const _isNightUntil = 4;
const _isNightAfter = 21;
const _snowIfMoreThan = 0;
const _rainIfMoreThan = 30;
const _windIfMoreThan = 5;
const _fogIfLessThan = 2;
const _cloudIfMoreThan = 30;

class Forecast {
  final String currentLocation;
  final String? icon;
  final String description;
  final double nowTemperature;
  final double todayMinTemperature;
  final double todayMaxTemperature;
  final double feelsLikeTemperature;
  final int nowTemperatureRound;
  final int todayMinTemperatureRound;
  final int todayMaxTemperatureRound;
  final int feelsLikeTemperatureRound;
  final String weatherSource;
  final DateTime lastUpdated;
  final SunriseSunset? sunriseSunset;
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
  bool _empty = false;
  bool get empty => _empty;

  late String _background;
  String get background => _background;

  Forecast({
    required this.currentLocation,
    this.icon,
    required this.description,
    required this.nowTemperature,
    required this.todayMinTemperature,
    required this.todayMaxTemperature,
    required this.feelsLikeTemperature,
    required this.weatherSource,
    required this.lastUpdated,
    this.sunriseSunset,
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
  })  : nowTemperatureRound = nowTemperature.round(),
        todayMinTemperatureRound = todayMinTemperature.round(),
        todayMaxTemperatureRound = todayMaxTemperature.round(),
        feelsLikeTemperatureRound = feelsLikeTemperature.round() {
    _setBackground();
  }

  factory Forecast.empty() => Forecast(
        currentLocation: '',
        description: '',
        nowTemperature: 0,
        todayMinTemperature: 0,
        todayMaxTemperature: 0,
        feelsLikeTemperature: 0,
        weatherSource: '',
        lastUpdated: DateTime(2001, 7, 4),
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

    bool isNight =
        lastUpdated.hour > _isNightAfter || lastUpdated.hour < _isNightUntil;
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

    if (cloudCoverPercentage != null &&
        cloudCoverPercentage! > _cloudIfMoreThan) {
      return isNight
          ? Assets.weatherBackgroundNightCloudyHouseNight
          : isCold
              ? Assets.weatherBackgroundDayCloudyColdHills
              : Assets.weatherBackgroundDayCloudyHouseMorning;
    }

    if (windSpeed > _windIfMoreThan) {
      return isNight
          ? Assets.weatherBackgroundNightWindyNight
          : Assets.weatherBackgroundDayWindy;
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
}

class SunriseSunset {
  final DateTime? sunrise;
  final DateTime? sunset;
  SunriseSunset({
    this.sunrise,
    this.sunset,
  });
}

class HourlyForecast {
  final List<HourForecast> hours;

  HourlyForecast({
    required this.hours,
  });

  factory HourlyForecast.withSunriseSunset({
    required List<HourForecast> hours,
    required SunriseSunset sunriseSunset,
  }) {
    final hours_ = List.of(hours);

    if (sunriseSunset.sunrise != null) {
      final sunriseIndex = hours_.indexWhere(
        (hour) => sunriseSunset.sunrise!.isBefore(hour.datetime),
      );
      if (sunriseIndex >= 0) {
        hours_.insert(sunriseIndex,
            HourForecast.sunrise(datetime: sunriseSunset.sunrise));
      } else {
        hours_.add(HourForecast.sunrise(datetime: sunriseSunset.sunrise));
      }
    }
    if (sunriseSunset.sunset != null) {
      final sunsetIndex = hours_.indexWhere(
        (hour) => sunriseSunset.sunset!.isBefore(hour.datetime),
      );
      if (sunsetIndex >= 0) {
        hours_.insert(
            sunsetIndex, HourForecast.sunset(datetime: sunriseSunset.sunset));
      } else {
        hours_.add(HourForecast.sunset(datetime: sunriseSunset.sunset));
      }
    }
    return HourlyForecast(hours: hours_);
  }
}

class HourForecast {
  final DateTime datetime;
  final double? temperature;
  final int? temperatureRound;
  final String icon;
  final String description;
  final int? precipitationProbability;

  bool _sunriseSunset;
  bool get sunriseSunset => _sunriseSunset;

  HourForecast({
    required this.datetime,
    required this.temperature,
    required this.icon,
    required this.description,
    this.precipitationProbability,
  })  : temperatureRound = temperature?.round(),
        _sunriseSunset = false;

  factory HourForecast.sunrise({required datetime}) => HourForecast(
        datetime: datetime,
        temperature: null,
        icon: 'sunrise',
        description: 'Sunrise',
      ).._sunriseSunset = true;

  factory HourForecast.sunset({required datetime}) => HourForecast(
        datetime: datetime,
        temperature: null,
        icon: 'sunset',
        description: 'Sunset',
      ).._sunriseSunset = true;
}

class DailyForecast {
  final List<DayForecast> days;

  DailyForecast({
    required this.days,
  });
}

class DayForecast {
  final DateTime datetime;
  final double minTemperature;
  final double maxTemperature;
  final int minTemperatureRound;
  final int maxTemperatureRound;
  final String icon;
  final int? precipitationProbability;

  DayForecast({
    required this.datetime,
    required this.minTemperature,
    required this.maxTemperature,
    required this.icon,
    this.precipitationProbability,
  })  : minTemperatureRound = minTemperature.round(),
        maxTemperatureRound = maxTemperature.round();
}
