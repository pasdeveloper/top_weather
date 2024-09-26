import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/models/weather_location.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeatherForecastByCoordinates(
      {required double latitude, required double longitude});

  Future<WeatherForecast> getWeatherForecastByLocationName(String locationName);

  Future<WeatherLocation?> searchWeatherLocation({required String name});
}
