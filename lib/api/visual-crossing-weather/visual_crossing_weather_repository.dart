import 'dart:async';
import 'dart:convert';
import 'dart:math';

// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:top_weather/api/visual-crossing-weather/visual_crossing_weather_data_model.dart';
import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/repository/weather_repository.dart';

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
  Future<WeatherForecast> getWeatherForecast(
      {required double latitude, required double longitude}) async {
    final url = _getLatLonUri(latitude, longitude);

    final data = await _getWeatherData(url);
    final forecast = _toWeatherForecast(data);
    return forecast;
  }

  Uri _getLatLonUri(double latitude, double longitude) => _baseUrl.replace(
      path:
          '${_baseUrl.path}/${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}');

  Uri _getLocationNameUri(String name) =>
      _baseUrl.replace(path: '${_baseUrl.path}/$name');

  Future<VisualCrossingWeatherDataModel> _getWeatherData(Uri url) async {
    final response = await http.get(url);
    final decodedJson = json.decode(response.body);
    // await Future.delayed(const Duration(milliseconds: 1000));
    // final decodedJson = json.decode(mockData);

    final data = VisualCrossingWeatherDataModel.fromJson(decodedJson);
    return data;
  }

  WeatherForecast _toWeatherForecast(VisualCrossingWeatherDataModel data) {
    final sunriseSunset = SunriseSunset(
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          data.currentConditions.sunriseEpoch! * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          data.currentConditions.sunsetEpoch! * 1000),
    );

    final hours = _getNext24Hours(data);
    final days = _getNext7Days(data);

    return WeatherForecast(
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

  List<HourForecast> _getNext24Hours(VisualCrossingWeatherDataModel data) {
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
            precipitationProbability: hourData.precipprob.round(),
          ),
        )
        .toList();
  }

  List<DayForecast> _getNext7Days(VisualCrossingWeatherDataModel data) {
    return data.days
        .sublist(0, min(data.days.length, 7))
        .map(
          (dayData) => DayForecast(
            datetime: DateTime.fromMillisecondsSinceEpoch(
                dayData.datetimeEpoch * 1000),
            minTemperature: dayData.tempmin!,
            maxTemperature: dayData.tempmax!,
            icon: dayData.icon,
            precipitationProbability: dayData.precipprob.round(),
          ),
        )
        .toList();
  }
}
