import 'package:top_weather/models/forecast/forecast.dart';
import 'package:top_weather/models/location.dart';

abstract class WeatherRepository {
  Future<Forecast> fetchWeatherForecast(Location location);

  Future<Location?> searchWeatherLocation(String name);
}
