import 'dart:math';

import 'package:top_weather/constants/assets.dart';

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

class Forecast {
  final String currentLocation;
  final ForecastIcon icon;
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
  bool _empty = false;
  bool get empty => _empty;

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
  })  : nowTemperatureRound = nowTemperature.round(),
        todayMinTemperatureRound = todayMinTemperature.round(),
        todayMaxTemperatureRound = todayMaxTemperature.round(),
        feelsLikeTemperatureRound = feelsLikeTemperature.round(),
        createdAt = DateTime.now() {
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
    return 'Forecast(currentLocation: $currentLocation, icon: $icon, description: $description, nowTemperature: $nowTemperature, todayMinTemperature: $todayMinTemperature, todayMaxTemperature: $todayMaxTemperature, feelsLikeTemperature: $feelsLikeTemperature, nowTemperatureRound: $nowTemperatureRound, todayMinTemperatureRound: $todayMinTemperatureRound, todayMaxTemperatureRound: $todayMaxTemperatureRound, feelsLikeTemperatureRound: $feelsLikeTemperatureRound, weatherSource: $weatherSource, weatherDataDatetime: $weatherDataDatetime, createdAt: $createdAt, hourlyForecast: $hourlyForecast, dailyForecast: $dailyForecast, windSpeed: $windSpeed, windDirection: $windDirection, pressure: $pressure, uvIndex: $uvIndex, snow: $snow, precipitationProbability: $precipitationProbability, visibility: $visibility, cloudCoverPercentage: $cloudCoverPercentage, sunrise: $sunrise, sunset: $sunset, _empty: $_empty, _background: $_background)';
  }
}

class HourlyForecast {
  final List<HourForecast> hours;

  HourlyForecast({
    required this.hours,
  });
}

class HourForecast {
  final DateTime datetime;
  final double temperature;
  final int temperatureRound;
  final ForecastIcon icon;
  final String description;
  final int? precipitationProbability;

  HourForecast({
    required this.datetime,
    required this.temperature,
    required this.icon,
    required this.description,
    this.precipitationProbability,
  }) : temperatureRound = temperature.round();
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
  final String description;
  final ForecastIcon icon;
  final int? precipitationProbability;
  final HourlyForecast? hourlyForecast;

  DayForecast({
    required this.datetime,
    required this.minTemperature,
    required this.maxTemperature,
    required this.icon,
    required this.description,
    this.precipitationProbability,
    this.hourlyForecast,
  })  : minTemperatureRound = minTemperature.round(),
        maxTemperatureRound = maxTemperature.round();
}

// enum
enum ForecastIcon {
  blizzard,
  blowingSnow,
  clearNight,
  clearDay,
  cloudy,
  cloudyWithRain,
  cloudyWithSnow,
  cloudyWithSunny,
  drizzle,
  flurries,
  hazeFogDustSmoke,
  heavyRain,
  heavySnow,
  icy,
  isolatedScatteredThunderstormsDay,
  isolatedScatteredThunderstormsNight,
  isolatedThunderstorms,
  mixedRainSnow,
  mixedRainSleetHail,
  mostlyClearDay,
  mostlyClearNight,
  mostlyCloudyDay,
  mostlyCloudyNight,
  notAvailable,
  partlyCloudyDay,
  partlyCloudyNight,
  scatteredShowersDay,
  scatteredShowersNight,
  scatteredSnowShowersDay,
  scatteredSnowShowersNight,
  showersRain,
  showersSnow,
  sleetHail,
  strongThunderstorms,
  sunnyAndCloudy,
  sunnyWithRainDarkSky,
  sunnyWithSnow,
  tornado,
  tropicalStormHurricane,
  veryCold,
  veryHot,
  windyBreezy
}
