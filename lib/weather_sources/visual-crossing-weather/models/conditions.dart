import 'dart:convert';

import 'package:equatable/equatable.dart';

class Conditions extends Equatable {
  final String datetime;
  final int datetimeEpoch;
  final double temp;
  final double feelslike;
  final double humidity;
  final double dew;
  final double? precip;
  final double? precipprob;
  final double snow;
  final double snowdepth;
  final double windspeed;
  final double? windspeedmax;
  final double? windspeedmean;
  final double? windspeedmin;
  final double winddir;
  final double pressure;
  final double visibility;
  final double cloudcover;
  final double solarradiation; // W/m2
  final double solarenergy; // MJ/m2
  final double uvindex;
  final String conditions;
  final ConditionsIcon icon;
  final int? sunriseEpoch;
  final int? sunsetEpoch;
  final double? moonphase;
  final int? moonriseEpoch;
  final int? moonsetEpoch;
  final double? tempmax;
  final double? tempmin;
  final double? feelslikemax;
  final double? feelslikemin;
  final String? description;
  final List<Conditions>? hours;

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

  const Conditions({
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
    required this.windspeed,
    this.windspeedmax,
    this.windspeedmean,
    this.windspeedmin,
    required this.winddir,
    required this.pressure,
    required this.visibility,
    required this.cloudcover,
    required this.solarradiation,
    required this.solarenergy,
    required this.uvindex,
    required this.conditions,
    required this.icon,
    this.sunriseEpoch,
    this.sunsetEpoch,
    this.moonphase,
    this.moonriseEpoch,
    this.moonsetEpoch,
    this.tempmax,
    this.tempmin,
    this.feelslikemax,
    this.feelslikemin,
    this.description,
    this.hours,
  });

  factory Conditions.fromMap(Map<String, dynamic> map) {
    return Conditions(
      datetime: map['datetime'] ?? '',
      datetimeEpoch: map['datetimeEpoch']?.toInt() ?? 0,
      temp: map['temp']?.toDouble() ?? 0.0,
      feelslike: map['feelslike']?.toDouble() ?? 0.0,
      humidity: map['humidity']?.toDouble() ?? 0.0,
      dew: map['dew']?.toDouble() ?? 0.0,
      precip: map['precip']?.toDouble(),
      precipprob: map['precipprob']?.toDouble(),
      snow: map['snow']?.toDouble() ?? 0.0,
      snowdepth: map['snowdepth']?.toDouble() ?? 0.0,
      windspeed: map['windspeed']?.toDouble() ?? 0.0,
      windspeedmax: map['windspeedmax']?.toDouble(),
      windspeedmean: map['windspeedmean']?.toDouble(),
      windspeedmin: map['windspeedmin']?.toDouble(),
      winddir: map['winddir']?.toDouble() ?? 0.0,
      pressure: map['pressure']?.toDouble() ?? 0.0,
      visibility: map['visibility']?.toDouble() ?? 0.0,
      cloudcover: map['cloudcover']?.toDouble() ?? 0.0,
      solarradiation: map['solarradiation']?.toDouble() ?? 0.0,
      solarenergy: map['solarenergy']?.toDouble() ?? 0.0,
      uvindex: map['uvindex']?.toDouble() ?? 0.0,
      conditions: map['conditions'] ?? '',
      icon: ConditionsIcon.fromMap(map['icon']),
      sunriseEpoch: map['sunriseEpoch']?.toInt(),
      sunsetEpoch: map['sunsetEpoch']?.toInt(),
      moonphase: map['moonphase']?.toDouble(),
      moonriseEpoch: map['moonriseEpoch']?.toInt(),
      moonsetEpoch: map['moonsetEpoch']?.toInt(),
      tempmax: map['tempmax']?.toDouble(),
      tempmin: map['tempmin']?.toDouble(),
      feelslikemax: map['feelslikemax']?.toDouble(),
      feelslikemin: map['feelslikemin']?.toDouble(),
      description: map['description'],
      hours: map['hours'] != null
          ? List<Conditions>.from(
              map['hours']?.map((x) => Conditions.fromMap(x)))
          : null,
    );
  }

  Conditions copyWith({
    String? datetime,
    int? datetimeEpoch,
    double? temp,
    double? feelslike,
    double? humidity,
    double? dew,
    double? precip,
    double? precipprob,
    double? snow,
    double? snowdepth,
    double? windspeed,
    double? windspeedmax,
    double? windspeedmean,
    double? windspeedmin,
    double? winddir,
    double? pressure,
    double? visibility,
    double? cloudcover,
    double? solarradiation,
    double? solarenergy,
    double? uvindex,
    String? conditions,
    ConditionsIcon? icon,
    int? sunriseEpoch,
    int? sunsetEpoch,
    double? moonphase,
    int? moonriseEpoch,
    int? moonsetEpoch,
    double? tempmax,
    double? tempmin,
    double? feelslikemax,
    double? feelslikemin,
    String? description,
    List<Conditions>? hours,
  }) {
    return Conditions(
      datetime: datetime ?? this.datetime,
      datetimeEpoch: datetimeEpoch ?? this.datetimeEpoch,
      temp: temp ?? this.temp,
      feelslike: feelslike ?? this.feelslike,
      humidity: humidity ?? this.humidity,
      dew: dew ?? this.dew,
      precip: precip ?? this.precip,
      precipprob: precipprob ?? this.precipprob,
      snow: snow ?? this.snow,
      snowdepth: snowdepth ?? this.snowdepth,
      windspeed: windspeed ?? this.windspeed,
      windspeedmax: windspeedmax ?? this.windspeedmax,
      windspeedmean: windspeedmean ?? this.windspeedmean,
      windspeedmin: windspeedmin ?? this.windspeedmin,
      winddir: winddir ?? this.winddir,
      pressure: pressure ?? this.pressure,
      visibility: visibility ?? this.visibility,
      cloudcover: cloudcover ?? this.cloudcover,
      solarradiation: solarradiation ?? this.solarradiation,
      solarenergy: solarenergy ?? this.solarenergy,
      uvindex: uvindex ?? this.uvindex,
      conditions: conditions ?? this.conditions,
      icon: icon ?? this.icon,
      sunriseEpoch: sunriseEpoch ?? this.sunriseEpoch,
      sunsetEpoch: sunsetEpoch ?? this.sunsetEpoch,
      moonphase: moonphase ?? this.moonphase,
      moonriseEpoch: moonriseEpoch ?? this.moonriseEpoch,
      moonsetEpoch: moonsetEpoch ?? this.moonsetEpoch,
      tempmax: tempmax ?? this.tempmax,
      tempmin: tempmin ?? this.tempmin,
      feelslikemax: feelslikemax ?? this.feelslikemax,
      feelslikemin: feelslikemin ?? this.feelslikemin,
      description: description ?? this.description,
      hours: hours ?? this.hours,
    );
  }

  @override
  String toString() {
    return 'Conditions(datetime: $datetime, datetimeEpoch: $datetimeEpoch, temp: $temp, feelslike: $feelslike, humidity: $humidity, dew: $dew, precip: $precip, precipprob: $precipprob, snow: $snow, snowdepth: $snowdepth, windspeed: $windspeed, windspeedmax: $windspeedmax, windspeedmean: $windspeedmean, windspeedmin: $windspeedmin, winddir: $winddir, pressure: $pressure, visibility: $visibility, cloudcover: $cloudcover, solarradiation: $solarradiation, solarenergy: $solarenergy, uvindex: $uvindex, conditions: $conditions, icon: $icon, sunriseEpoch: $sunriseEpoch, sunsetEpoch: $sunsetEpoch, moonphase: $moonphase, moonriseEpoch: $moonriseEpoch, moonsetEpoch: $moonsetEpoch, tempmax: $tempmax, tempmin: $tempmin, feelslikemax: $feelslikemax, feelslikemin: $feelslikemin, description: $description, hours: $hours)';
  }

  @override
  List<Object?> get props {
    return [
      datetime,
      datetimeEpoch,
      temp,
      feelslike,
      humidity,
      dew,
      precip,
      precipprob,
      snow,
      snowdepth,
      windspeed,
      windspeedmax,
      windspeedmean,
      windspeedmin,
      winddir,
      pressure,
      visibility,
      cloudcover,
      solarradiation,
      solarenergy,
      uvindex,
      conditions,
      icon,
      sunriseEpoch,
      sunsetEpoch,
      moonphase,
      moonriseEpoch,
      moonsetEpoch,
      tempmax,
      tempmin,
      feelslikemax,
      feelslikemin,
      description,
      hours,
    ];
  }

  factory Conditions.fromJson(String source) =>
      Conditions.fromMap(json.decode(source));
}

// enum
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

// enum
enum ConditionsIcon {
  snow,
  snowShowersDay,
  snowShowersNight,
  thunderRain,
  thunderShowersDay,
  thunderShowersNight,
  rain,
  showersDay,
  showersNight,
  fog,
  wind,
  cloudy,
  partlyCloudyDay,
  partlyCloudyNight,
  clearDay,
  clearNight;

  factory ConditionsIcon.fromMap(String name) {
    switch (name) {
      case 'snow':
        return ConditionsIcon.snow;
      case 'snow-showers-day':
        return ConditionsIcon.snowShowersDay;
      case 'snow-showers-night':
        return ConditionsIcon.snowShowersNight;
      case 'thunder-rain':
        return ConditionsIcon.thunderRain;
      case 'thunder-showers-day':
        return ConditionsIcon.thunderShowersDay;
      case 'thunder-showers-night':
        return ConditionsIcon.thunderShowersNight;
      case 'rain':
        return ConditionsIcon.rain;
      case 'showers-day':
        return ConditionsIcon.showersDay;
      case 'showers-night':
        return ConditionsIcon.showersNight;
      case 'fog':
        return ConditionsIcon.fog;
      case 'wind':
        return ConditionsIcon.wind;
      case 'cloudy':
        return ConditionsIcon.cloudy;
      case 'partly-cloudy-day':
        return ConditionsIcon.partlyCloudyDay;
      case 'partly-cloudy-night':
        return ConditionsIcon.partlyCloudyNight;
      case 'clear-day':
        return ConditionsIcon.clearDay;
      case 'clear-night':
        return ConditionsIcon.clearNight;
      default:
        throw Exception('Unknown weather icon: $name');
    }
  }
}
