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
      // TODO: superato limite di richieste
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
    final sunriseSunset = SunriseSunset(
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          data.currentConditions.sunriseEpoch! * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          data.currentConditions.sunsetEpoch! * 1000),
    );

    final hours = _getNext24Hours(data);
    final days = _getNext7Days(data);

    return Forecast(
      currentLocation: data.resolvedAddress,
      icon: data.currentConditions.icon,
      description: data.currentConditions.conditions,
      nowTemperature: data.currentConditions.temp,
      todayMinTemperature: data.days[0].tempmin ?? 0,
      todayMaxTemperature: data.days[0].tempmax ?? 0,
      feelsLikeTemperature: data.currentConditions.feelslike,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
          data.currentConditions.datetimeEpoch * 1000),
      sunriseSunset: sunriseSunset,
      hourlyForecast: HourlyForecast.withSunriseSunset(
        hours: hours,
        sunriseSunset: sunriseSunset,
      ),
      dailyForecast: DailyForecast(days: days),
    );
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
          (hourData) => HourForecast(
            datetime: DateTime.fromMillisecondsSinceEpoch(
                hourData.datetimeEpoch * 1000),
            temperature: hourData.temp,
            icon: hourData.icon,
            description: hourData.conditions,
            precipitationProbability: hourData.precipprob?.round(),
          ),
        )
        .toList();
  }

  List<DayForecast> _getNext7Days(WeatherData data) {
    return data.days
        .sublist(0, min(data.days.length, 7))
        .map(
          (dayData) => DayForecast(
            datetime: DateTime.fromMillisecondsSinceEpoch(
                dayData.datetimeEpoch * 1000),
            minTemperature: dayData.tempmin!,
            maxTemperature: dayData.tempmax!,
            icon: dayData.icon,
            precipitationProbability: dayData.precipprob?.round(),
          ),
        )
        .toList();
  }
}
