import 'dart:math';

import 'package:flutter/material.dart';
import 'package:top_weather/core/locator.dart';
import 'package:top_weather/models/weather_data.dart';
import 'package:top_weather/services/weather_service.dart';
import 'package:top_weather/widgets/forecast_hero.dart';
import 'package:top_weather/widgets/sunrise_sunset_card.dart';
import 'package:top_weather/widgets/timeline_card.dart';
import 'package:top_weather/widgets/week_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _weatherService = locator<WeatherService>();
  late Future<WeatherData> _weatherData$;

  @override
  void initState() {
    super.initState();
    _weatherData$ = _weatherService.getByLocationName('Rome, italy');
  }

  void _loadWeatherData() {
    setState(() {
      _weatherData$ = _weatherService.getByLocationName('Rome, italy');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: FutureBuilder(
          future: _weatherData$,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Text(snapshot.data!.resolvedAddress);
            }

            return const Text('Top Weather');
          },
        ),
        actions: [
          IconButton(
              onPressed: _loadWeatherData,
              icon: const Icon(Icons.location_searching))
        ],
      ),
      body: FutureBuilder(
        future: _weatherData$,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading();
          }

          if (snapshot.hasError) {
            return _errorMessage(
              snapshot.error.toString(),
            );
          }

          if (snapshot.data == null) {
            return _errorMessage('No data');
          }

          var data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ForecastHero(
                  currentConditions: data.currentConditions,
                  currentDayConditions: data.days[0],
                ),
                if (data.days[0].hours != null)
                  TimelineCard(_getNext24Hours(data.days[0], data.days[1])),
                const SizedBox(
                  height: 10,
                ),
                WeekCard(_getNext7Days(data)),
                const SizedBox(
                  height: 10,
                ),
                SunriseSunsetCard(data.currentConditions),
              ],
            ),
          );
        },
      ),
    );
  }
}

List<Conditions> _getNext7Days(WeatherData data) {
  return data.days.sublist(0, min(data.days.length, 7));
}

List<Conditions> _getNext24Hours(Conditions today, Conditions tomorrow) {
  if (today.hours == null || tomorrow.hours == null) return [];

  var currentHour = DateTime.now().hour;
  return [...today.hours!, ...tomorrow.hours!]
      .sublist(currentHour, currentHour + 24);
}

Widget _loading() => const Center(
      child: CircularProgressIndicator(),
    );

Widget _errorMessage(String message) => Center(
      child: Text(message),
    );
