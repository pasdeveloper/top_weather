class WeatherData {
  int queryCost;
  double latitude;
  double longitude;
  String resolvedAddress;
  String address;
  String timezone;
  int tzoffset;
  String description;
  List<CurrentConditions> days;
  List<dynamic> alerts;
  Map<String, Station> stations;
  CurrentConditions currentConditions;

  WeatherData({
    required this.queryCost,
    required this.latitude,
    required this.longitude,
    required this.resolvedAddress,
    required this.address,
    required this.timezone,
    required this.tzoffset,
    required this.description,
    required this.days,
    required this.alerts,
    required this.stations,
    required this.currentConditions,
  });
}

class CurrentConditions {
  String datetime;
  int datetimeEpoch;
  double temp;
  double feelslike;
  double humidity;
  double dew;
  int precip;
  double precipprob;
  int snow;
  int snowdepth;
  dynamic preciptype;
  double windgust;
  double windspeed;
  double winddir;
  double pressure;
  double visibility;
  double cloudcover;
  double solarradiation;
  double solarenergy;
  int uvindex;
  String conditions;
  String icon;
  List<String>? stations;
  String source;
  String? sunrise;
  int? sunriseEpoch;
  String? sunset;
  int? sunsetEpoch;
  double? moonphase;
  double? tempmax;
  double? tempmin;
  double? feelslikemax;
  double? feelslikemin;
  int? precipcover;
  int? severerisk;
  String? description;
  List<CurrentConditions>? hours;

  CurrentConditions({
    required this.datetime,
    required this.datetimeEpoch,
    required this.temp,
    required this.feelslike,
    required this.humidity,
    required this.dew,
    required this.precip,
    required this.precipprob,
    required this.snow,
    required this.snowdepth,
    required this.preciptype,
    required this.windgust,
    required this.windspeed,
    required this.winddir,
    required this.pressure,
    required this.visibility,
    required this.cloudcover,
    required this.solarradiation,
    required this.solarenergy,
    required this.uvindex,
    required this.conditions,
    required this.icon,
    required this.stations,
    required this.source,
    this.sunrise,
    this.sunriseEpoch,
    this.sunset,
    this.sunsetEpoch,
    this.moonphase,
    this.tempmax,
    this.tempmin,
    this.feelslikemax,
    this.feelslikemin,
    this.precipcover,
    this.severerisk,
    this.description,
    this.hours,
  });
}

class Station {
  int distance;
  double latitude;
  double longitude;
  int useCount;
  String id;
  String name;
  int quality;
  int contribution;

  Station({
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.useCount,
    required this.id,
    required this.name,
    required this.quality,
    required this.contribution,
  });
}
