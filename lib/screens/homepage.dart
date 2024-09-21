import 'package:flutter/material.dart';
import 'package:top_weather/core/locator.dart';
import 'package:top_weather/models/weather_data.dart';
import 'package:top_weather/services/weather_service.dart';
import 'package:top_weather/widgets/forecast_hero.dart';

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
        title: FutureBuilder(
          future: _weatherData$,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loading();
            }

            if (snapshot.data != null) {
              return Text(snapshot.data!.resolvedAddress);
            }

            return const Text('Weather');
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
              children: [ForecastHero(data.currentConditions)],
            ),
          );
        },
      ),
    );
  }
}

Widget _loading() => const Center(
      child: CircularProgressIndicator(),
    );

Widget _errorMessage(String message) => Center(
      child: Text(message),
    );
