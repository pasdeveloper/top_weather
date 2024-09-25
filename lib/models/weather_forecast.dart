class WeatherForecast {
  final String currentLocation;
  final String icon;
  final String description;
  final double nowTemperature;
  final double todayMinTemperature;
  final double todayMaxTemperature;
  final double feelsLikeTemperature;
  final DateTime lastUpdated;
  SunriseSunset? sunriseSunset;
  HourlyForecast? hourlyForecast;
  DailyForecast? dailyForecast;

  WeatherForecast({
    required this.currentLocation,
    required this.icon,
    required this.description,
    required this.nowTemperature,
    required this.todayMinTemperature,
    required this.todayMaxTemperature,
    required this.feelsLikeTemperature,
    required this.lastUpdated,
    this.sunriseSunset,
    this.hourlyForecast,
    this.dailyForecast,
  });
}

class SunriseSunset {
  final DateTime sunrise;
  final DateTime sunset;
  SunriseSunset({
    required this.sunrise,
    required this.sunset,
  });
}

class HourlyForecast {
  final List<HourForecast> hours;

  HourlyForecast({
    required this.hours,
  });

// TODO: inserire sunrise, sunset
  factory HourlyForecast.withSunriseSunset({
    required List<HourForecast> hours,
    required SunriseSunset sunriseSunset,
  }) {
    return HourlyForecast(hours: hours);
  }
}

class HourForecast {
  final DateTime datetime;
  final double? temperature;
  final String icon;
  final String? description;
  final int? precipitationProbability;

  HourForecast({
    required this.datetime,
    required this.temperature,
    required this.icon,
    required this.description,
    this.precipitationProbability,
  });

  HourForecast.sunrise({required this.datetime})
      : icon = 'sunrise',
        description = null,
        precipitationProbability = null,
        temperature = null;

  HourForecast.sunset({required this.datetime})
      : icon = 'sunset',
        description = null,
        precipitationProbability = null,
        temperature = null;
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
  final String icon;
  final int? precipitationProbability;

  DayForecast({
    required this.datetime,
    required this.minTemperature,
    required this.maxTemperature,
    required this.icon,
    this.precipitationProbability,
  });
}
