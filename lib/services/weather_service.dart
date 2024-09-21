import 'package:http/http.dart' as http;

class WeatherService {
  final _baseUrl = Uri.https(
      'weather.visualcrossing.com',
      'VisualCrossingWebServices/rest/services/timeline',
      {'key': const String.fromEnvironment('API_KEY')});

  // Future<WeatherData>
  void getByLatLon(num lat, num lon) {
    final url = _baseUrl.replace(
      path:
          '${_baseUrl.path}/${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}',
    );

    return _getWeatherData(url);
  }

  // Future<WeatherData>
  void getByLocationName(String name) {
    final url = _baseUrl.replace(
      path: '${_baseUrl.path}/$name',
    );

    return _getWeatherData(url);
  }

  // Future<WeatherData>
  void _getWeatherData(Uri url) async {
    final response = await http.get(url);

    print(response.body);
  }
}
