import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/bloc/theme/theme_cubit.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/screens/locations.dart';
import 'package:top_weather/widgets/forecast_hero.dart';
import 'package:top_weather/widgets/sunrise_sunset_card.dart';
import 'package:top_weather/widgets/timeline_card.dart';
import 'package:top_weather/widgets/week_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void _openLocations(BuildContext context) async {
    Navigator.push<Location>(
        context,
        MaterialPageRoute(
          builder: (context) => const Locations(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForecastCubit>().state;
    return BlocListener<SelectedLocationBloc, SelectedLocationState>(
      listener: (context, selectedLocationState) {
        if (selectedLocationState.selectedLocation != null) {
          context
              .read<ForecastCubit>()
              .fetchForecast(selectedLocationState.selectedLocation!);
        } else {
          context.read<ForecastCubit>().emptyForecast();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.transparent,
            // systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: Text(context
                    .watch<SelectedLocationBloc>()
                    .state
                    .selectedLocation
                    ?.name ??
                'Top Weather'),
            actions: [
              IconButton(
                  onPressed: () {
                    final themeCubit = context.read<ThemeCubit>();
                    final currentTheme = themeCubit.state.themeMode;
                    themeCubit.setTheme(currentTheme == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light);
                  },
                  icon: const Icon(Icons.brightness_6)),
              IconButton(
                  onPressed: () => _openLocations(context),
                  icon: const Icon(Icons.list)),
            ],
          ),
          body: switch (state.status) {
            ForecastStatus.empty => _emptyWeather(context),
            ForecastStatus.loading => _loading(),
            ForecastStatus.ok => _body(context, state.forecast),
            ForecastStatus.error => state.forecast.empty
                ? _emptyWeather(context)
                : _body(context, state.forecast),
          }),
    );
  }
}

Widget _body(BuildContext context, Forecast forecast) =>
    RefreshIndicator.adaptive(
      onRefresh: () => Future(() {
        if (context.mounted) {
          context.read<ForecastCubit>().fetchForecast(
              context.read<SelectedLocationBloc>().state.selectedLocation!);
        }
      }),
      child: SingleChildScrollView(
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
