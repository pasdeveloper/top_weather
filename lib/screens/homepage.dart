import 'package:flutter/material.dart';
import 'package:top_weather/configurations/locator.dart';
import 'package:top_weather/services/weather_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final weatherService = locator<WeatherService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
              onPressed: () => weatherService.getByLocationName('Rome, italy'),
              icon: const Icon(Icons.location_searching))
        ],
      ),
      body: const Placeholder(),
    );
  }
}
