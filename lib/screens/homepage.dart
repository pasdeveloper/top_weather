import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/blocs/bloc/weather_forecast_bloc.dart';
import 'package:top_weather/widgets/forecast_hero.dart';
import 'package:top_weather/widgets/sunrise_sunset_card.dart';
import 'package:top_weather/widgets/timeline_card.dart';
import 'package:top_weather/widgets/week_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherForecastBloc = context.read<WeatherForecastBloc>();
    final forecast = context.watch<WeatherForecastBloc>().state.forecast;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(forecast?.currentLocation ?? 'Top Weather'),
        actions: [
          IconButton(
              onPressed: () => weatherForecastBloc.add(
                  const GetLatLonForecastEvent(
                      latitude: 41.9032, longitude: 12.4957)),
              icon: const Icon(Icons.location_searching))
        ],
      ),
      body: forecast == null
          ? _emptyWeather()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ForecastHero(forecast: forecast),
                  if (forecast.hourlyForecast != null)
                    TimelineCard(hourlyForecast: forecast.hourlyForecast!),
                  if (forecast.dailyForecast != null)
                    const SizedBox(
                      height: 10,
                    ),
                  if (forecast.dailyForecast != null)
                    WeekCard(dailyForecast: forecast.dailyForecast!),
                  const SizedBox(
                    height: 10,
                  ),
                  if (forecast.sunriseSunset != null)
                    SunriseSunsetCard(sunriseSunset: forecast.sunriseSunset!),
                ],
              ),
            ),
    );
  }
}

Widget _emptyWeather() => const Center(
      child: Text(
        'No location selected',
        style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
      ),
    );
