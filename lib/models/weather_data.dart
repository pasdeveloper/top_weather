class WeatherData {
  double queryCost;
  double latitude;
  double longitude;
  String resolvedAddress;
  String address;
  String timezone;
  double tzoffset;
  String description;
  List<Conditions> days;
  List<dynamic> alerts;
  Map<String, Station> stations;
  Conditions currentConditions;

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

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      queryCost: json['queryCost'].toDouble(),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      resolvedAddress: json['resolvedAddress'],
      address: json['address'],
      timezone: json['timezone'],
      tzoffset: json['tzoffset'].toDouble(),
      description: json['description'],
      days: (json['days'] as List)
          .map((day) => Conditions.fromJson(day))
          .toList(),
      alerts: json['alerts'] as List<dynamic>,
      stations: (json['stations'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Station.fromJson(value)),
      ),
      currentConditions: Conditions.fromJson(json['currentConditions']),
    );
  }
}

class Conditions {
  String datetime;
  int datetimeEpoch;
  double temp;
  double feelslike;
  double humidity;
  double dew;
  double precip;
  double precipprob;
  double snow;
  double snowdepth;
  dynamic preciptype;
  double windgust;
  double windspeed;
  double winddir;
  double pressure;
  double visibility;
  double cloudcover;
  double solarradiation;
  double solarenergy;
  double uvindex;
  String conditions;
  String icon;
  List<String>? stations;
  String source;
  String? sunrise;
  double? sunriseEpoch;
  String? sunset;
  double? sunsetEpoch;
  double? moonphase;
  double? tempmax;
  double? tempmin;
  double? feelslikemax;
  double? feelslikemin;
  double? precipcover;
  double? severerisk;
  String? description;
  List<Conditions>? hours;

  Moonphase? get moonphaseValue {
    if (moonphase == null) return null;
    if (moonphase! == 0) return Moonphase.newMoon;
    if (moonphase! < .25) return Moonphase.waxingCrescent;
    if (moonphase! == .25) return Moonphase.firstQuarter;
    if (moonphase! < .5) return Moonphase.waxingGibbous;
    if (moonphase! == .5) return Moonphase.fullMoon;
    if (moonphase! < .75) return Moonphase.waningGibbous;
    if (moonphase! == .75) return Moonphase.lastQuarter;
    if (moonphase! > .75) return Moonphase.waningCrescent;
    return null;
  }

  Conditions({
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

  factory Conditions.fromJson(Map<String, dynamic> json) {
    return Conditions(
      datetime: json['datetime'],
      datetimeEpoch: json['datetimeEpoch'],
      temp: json['temp'].toDouble(),
      feelslike: json['feelslike'].toDouble(),
      humidity: json['humidity'].toDouble(),
      dew: json['dew'].toDouble(),
      precip: json['precip'].toDouble(),
      precipprob: json['precipprob'].toDouble(),
      snow: json['snow'].toDouble(),
      snowdepth: json['snowdepth'].toDouble(),
      preciptype: json['preciptype'],
      windgust: json['windgust'].toDouble(),
      windspeed: json['windspeed'].toDouble(),
      winddir: json['winddir'].toDouble(),
      pressure: json['pressure'].toDouble(),
      visibility: json['visibility'].toDouble(),
      cloudcover: json['cloudcover'].toDouble(),
      solarradiation: json['solarradiation'].toDouble(),
      solarenergy: json['solarenergy'].toDouble(),
      uvindex: json['uvindex'].toDouble(),
      conditions: json['conditions'],
      icon: json['icon'],
      stations:
          json['stations'] != null ? List<String>.from(json['stations']) : null,
      source: json['source'],
      sunrise: json['sunrise'],
      sunriseEpoch: json['sunriseEpoch']?.toDouble(),
      sunset: json['sunset'],
      sunsetEpoch: json['sunsetEpoch']?.toDouble(),
      moonphase: json['moonphase']?.toDouble(),
      tempmax: json['tempmax']?.toDouble(),
      tempmin: json['tempmin']?.toDouble(),
      feelslikemax: json['feelslikemax']?.toDouble(),
      feelslikemin: json['feelslikemin']?.toDouble(),
      precipcover: json['precipcover']?.toDouble(),
      severerisk: json['severerisk']?.toDouble(),
      description: json['description'],
      hours: json['hours'] != null
          ? (json['hours'] as List)
              .map((hour) => Conditions.fromJson(hour))
              .toList()
          : null,
    );
  }
}

enum Moonphase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

class Station {
  double distance;
  double latitude;
  double longitude;
  double useCount;
  String id;
  String name;
  double quality;
  double contribution;

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

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      distance: json['distance'].toDouble(),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      useCount: json['useCount'].toDouble(),
      id: json['id'],
      name: json['name'],
      quality: json['quality'].toDouble(),
      contribution: json['contribution'].toDouble(),
    );
  }
}
