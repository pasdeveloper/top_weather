class AppImages {
  static const _basePath = 'assets/images/';

  static const _paths = {
    'snow': '${_basePath}snow.svg',
    'rain': '${_basePath}rain.svg',
    'fog': '${_basePath}windy.svg', //same as wind
    'wind': '${_basePath}windy.svg',
    'cloudy': '${_basePath}cloudy.svg',
    'partly-cloudy-day': '${_basePath}partly-cloud-day.svg',
    'partly-cloudy-night': '${_basePath}partly-cloud-night.svg',
    'clear-day': '${_basePath}clear-day.svg',
    'clear-night': '${_basePath}clear-night.svg',
  };

  static String iconPathByName(String name) {
    return _paths[name] ?? '';
  }
}
