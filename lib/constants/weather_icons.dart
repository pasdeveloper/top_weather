import 'package:top_weather/constants/assets.dart';

class WeatherIcons {
  static final _paths = {
    'snow': Assets.weatherIconSnow,
    'rain': Assets.weatherIconRain,
    'fog': Assets.weatherIconWindy, //same as wind
    'wind': Assets.weatherIconWindy,
    'cloudy': Assets.weatherIconCloudy,
    'partly-cloudy-day': Assets.weatherIconPartlyCloudDay,
    'partly-cloudy-night': Assets.weatherIconPartlyCloudNight,
    'clear-day': Assets.weatherIconClearDay,
    'clear-night': Assets.weatherIconClearNight,
    'sunrise': Assets.weatherIconSunrise,
    'sunset': Assets.weatherIconSunset,
  };

  static String iconPathByName(String name) {
    return _paths[name] ?? '';
  }
}
