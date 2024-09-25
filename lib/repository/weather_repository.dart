import 'package:top_weather/models/weather_forecast.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeatherForecast(
      {required double latitude, required double longitude});
}
