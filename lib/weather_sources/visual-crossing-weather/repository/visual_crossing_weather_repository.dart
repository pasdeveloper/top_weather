import 'dart:async';
import 'dart:convert';
import 'dart:math';

// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:top_weather/core/http_harror_handling.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/repository/weather_repository.dart';
import 'package:top_weather/weather_sources/visual-crossing-weather/exceptions/data_fetch_exception.dart';
import 'package:top_weather/weather_sources/visual-crossing-weather/models/conditions.dart';
import 'package:top_weather/weather_sources/visual-crossing-weather/models/weather_data.dart';

class VisualCrossingWeatherRepository implements WeatherRepository {
  final _baseUrl = Uri.https(
    'weather.visualcrossing.com',
    'VisualCrossingWebServices/rest/services/timeline',
    {
      'key': const String.fromEnvironment('API_KEY'),
      'unitGroup': 'metric',
    },
  );

  @override
  Future<Forecast> fetchWeatherForecast(Location location) async {
    final url = _getLatLonUri(location.latitude, location.longitude);

    final data = await _getWeatherData(url);
    final forecast = _toWeatherForecast(data);
    return forecast;
  }

  @override
  Future<Location?> searchWeatherLocation(String name) async {
    final url = _getLocationNameUri(name);
    try {
      final data = await _getWeatherData(url);
      return Location(
        name: data.resolvedAddress,
        latitude: data.latitude,
        longitude: data.longitude,
      );
    } on DataFetchException catch (e) {
      if (e.reason == DataFetchExceptionReason.dataNotFound) return null;
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Uri _getLatLonUri(double latitude, double longitude) => _baseUrl.replace(
      path:
          '${_baseUrl.path}/${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}');

  Uri _getLocationNameUri(String name) =>
      _baseUrl.replace(path: '${_baseUrl.path}/$name');

  Future<WeatherData> _getWeatherData(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 400) {
      throw DataFetchException(
          message: httpErrorToMessage(response),
          reason: DataFetchExceptionReason.dataNotFound);
    }

    if (response.statusCode == 429) {
      throw 'Today\'s request limit reached';
    }

    if (response.statusCode != 200) {
      throw DataFetchException(
          message: httpErrorToMessage(response),
          reason: DataFetchExceptionReason.other);
    }

    final decodedJson = json.decode(response.body);

    final data = WeatherData.fromMap(decodedJson);
    return data;
  }

  Forecast _toWeatherForecast(WeatherData data) {
    final sunriseSunset = _getNextSunriseSunset(data);

    final hours = _getNext24Hours(data);
    final days = _getNext7Days(data);

    final now = data.currentConditions;

    return Forecast(
      currentLocation: data.resolvedAddress,
      icon: now.icon,
      description: now.conditions,
      nowTemperature: now.temp,
      todayMinTemperature: data.days[0].tempmin ?? 0,
      todayMaxTemperature: data.days[0].tempmax ?? 0,
      feelsLikeTemperature: now.feelslike,
      weatherSource: 'Visual Crossing Weather',
      weatherDataDatetime: _toDateTime(now.datetimeEpoch),
      sunriseSunset: sunriseSunset,
      hourlyForecast: HourlyForecast.withSunriseSunset(
        hours: hours,
        sunriseSunset: sunriseSunset,
      ),
      dailyForecast: DailyForecast(days: days),
      windSpeed: now.windspeed,
      windDirection: now.winddir,
      pressure: now.pressure,
      uvIndex: now.uvindex,
      snow: now.snow,
      precipitationProbability: now.precipprob,
      visibility: now.visibility,
      cloudCoverPercentage: now.cloudcover,
    );
  }

  SunriseSunset _getNextSunriseSunset(WeatherData data) {
    final now = _toDateTime(data.currentConditions.datetimeEpoch);
    DateTime? nextSunriseDateTime =
        _toDateTime(data.currentConditions.sunriseEpoch!);
    if (nextSunriseDateTime.isBefore(now)) {
      nextSunriseDateTime =
          data.days.length > 1 ? _toDateTime(data.days[1].sunriseEpoch!) : null;
    }
    DateTime? nextSunsetDateTime =
        _toDateTime(data.currentConditions.sunsetEpoch!);
    if (nextSunsetDateTime.isBefore(now)) {
      nextSunsetDateTime =
          data.days.length > 1 ? _toDateTime(data.days[1].sunsetEpoch!) : null;
    }
    return SunriseSunset(
      sunrise: nextSunriseDateTime,
      sunset: nextSunsetDateTime,
    );
  }

  DateTime _toDateTime(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  List<HourForecast> _getNext24Hours(WeatherData data) {
    if (data.days.isEmpty) return [];
    final todaysHours = data.days[0].hours ?? <Conditions>[];
    final tomorrowsHours = data.days.length > 1
        ? data.days[1].hours ?? <Conditions>[]
        : <Conditions>[];

    var currentHour = DateTime.now().hour;
    final todayAndTomorrow = [...todaysHours, ...tomorrowsHours];
    return todayAndTomorrow
        .sublist(
            max(currentHour, 0), min(todayAndTomorrow.length, currentHour + 24))
        .map(
          (hourData) => _toHourForecast(hourData),
        )
        .toList();
  }

  HourForecast _toHourForecast(Conditions conditions) => HourForecast(
        datetime: _toDateTime(conditions.datetimeEpoch),
        temperature: conditions.temp,
        icon: conditions.icon,
        description: conditions.conditions,
        precipitationProbability: conditions.precipprob?.round(),
      );

  List<DayForecast> _getNext7Days(WeatherData data) {
    return data.days.sublist(0, min(data.days.length, 7)).map(
      (dayData) {
        final hourlyForecast = dayData.hours == null
            ? null
            : HourlyForecast(
                hours: dayData.hours!
                    .map((hourData) => _toHourForecast(hourData))
                    .toList(),
              );
        return DayForecast(
          datetime: _toDateTime(dayData.datetimeEpoch),
          minTemperature: dayData.tempmin!,
          maxTemperature: dayData.tempmax!,
          icon: dayData.icon,
          description: dayData.conditions,
          precipitationProbability: dayData.precipprob?.round(),
          hourlyForecast: hourlyForecast,
        );
      },
    ).toList();
  }
}
