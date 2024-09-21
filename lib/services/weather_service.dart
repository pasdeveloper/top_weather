import 'dart:async';
import 'dart:convert';

// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:top_weather/models/weather_data.dart';
// ignore: unused_import
import 'package:top_weather/services/mock_response.dart';

class WeatherService {
  final _baseUrl = Uri.https('weather.visualcrossing.com',
      'VisualCrossingWebServices/rest/services/timeline', {
    'key': const String.fromEnvironment('API_KEY'),
    'unitGroup': 'metric',
  });

  Future<WeatherData> getByLatLon(num lat, num lon) {
    final url = _baseUrl.replace(
      path:
          '${_baseUrl.path}/${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}',
    );

    return _getWeatherData(url);
  }

  Future<WeatherData> getByLocationName(String name) {
    final url = _baseUrl.replace(
      path: '${_baseUrl.path}/$name',
    );

    return _getWeatherData(url);
  }

  Future<WeatherData> _getWeatherData(Uri url) async {
    // final response = await http.get(url);
    // final decodedJson = json.decode(response.body);
    await Future.delayed(const Duration(seconds: 1));
    final decodedJson = json.decode(mockRsponse);

    final data = WeatherData.fromJson(decodedJson);
    return data;
  }
}
