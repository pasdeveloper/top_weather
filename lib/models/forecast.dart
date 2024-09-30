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
  final DateTime lastUpdated;
  final SunriseSunset? sunriseSunset;
  final HourlyForecast? hourlyForecast;
  final DailyForecast? dailyForecast;

  bool _empty = false;
  bool get empty => _empty;

  Forecast({
    required this.currentLocation,
    this.icon,
    required this.description,
    required this.nowTemperature,
    required this.todayMinTemperature,
    required this.todayMaxTemperature,
    required this.feelsLikeTemperature,
    required this.lastUpdated,
    this.sunriseSunset,
    this.hourlyForecast,
    this.dailyForecast,
  })  : nowTemperatureRound = nowTemperature.round(),
        todayMinTemperatureRound = todayMinTemperature.round(),
        todayMaxTemperatureRound = todayMaxTemperature.round(),
        feelsLikeTemperatureRound = feelsLikeTemperature.round();

  factory Forecast.empty() => Forecast(
        currentLocation: '',
        description: '',
        nowTemperature: 0,
        todayMinTemperature: 0,
        todayMaxTemperature: 0,
        feelsLikeTemperature: 0,
        lastUpdated: DateTime(2001, 7, 4),
      ).._empty = true;
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
