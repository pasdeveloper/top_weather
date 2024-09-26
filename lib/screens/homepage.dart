import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/blocs/weather_forecast/weather_forecast_bloc.dart';
import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/models/weather_location.dart';
import 'package:top_weather/screens/locations.dart';
import 'package:top_weather/widgets/forecast_hero.dart';
import 'package:top_weather/widgets/sunrise_sunset_card.dart';
import 'package:top_weather/widgets/timeline_card.dart';
import 'package:top_weather/widgets/week_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void _onSelectLocation(BuildContext context) async {
    final selectedLocation = await Navigator.push<WeatherLocation>(
        context,
        MaterialPageRoute(
          builder: (context) => const Locations(),
        ));
    if (selectedLocation == null || !context.mounted) return;
    context
        .read<WeatherForecastBloc>()
        .add(GetLocationForecastEvent(location: selectedLocation));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WeatherForecastBloc>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(state.status == WeatherForecastStatus.complete
            ? state.forecast.currentLocation
            : 'Top Weather'),
        actions: [
          IconButton(
              onPressed: () => _onSelectLocation(context),
              icon: const Icon(Icons.location_on))
        ],
      ),
      body: switch (state.status) {
        WeatherForecastStatus.empty => _emptyWeather(context),
        WeatherForecastStatus.loading => _loading(),
        WeatherForecastStatus.complete => _body(state.forecast),
        // WeatherForecastStatus.error =>
        //   state.forecast.empty ? _emptyWeather() : _body(state.forecast),
      },
    );
  }
}

Widget _body(WeatherForecast forecast) => SingleChildScrollView(
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
    );

Widget _loading() => const Center(child: CircularProgressIndicator.adaptive());

Widget _emptyWeather(BuildContext context) => Center(
      child: Text(
        'No location selected',
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.5)),
      ),
    );
