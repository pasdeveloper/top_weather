import 'package:get_it/get_it.dart';
import 'package:top_weather/services/weather_service.dart';

final locator = GetIt.instance;

void locatorSetup() {
  locator.registerSingleton<WeatherService>(WeatherService());
}
