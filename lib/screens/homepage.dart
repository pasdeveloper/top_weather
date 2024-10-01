import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/widgets/daily_forecast_card.dart';
import 'package:top_weather/widgets/forecast_persistent_header_delegate.dart';
import 'package:top_weather/widgets/hourly_forecast_card.dart';
import 'package:top_weather/widgets/pressure_card.dart';
import 'package:top_weather/widgets/rain_chance_card.dart';
import 'package:top_weather/widgets/source_information.dart';
import 'package:top_weather/widgets/uv_index_card.dart';
import 'package:top_weather/widgets/wind_direction_card.dart';
import 'package:top_weather/widgets/wind_speed_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForecastCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
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
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  ForecastPersistentHeaderDelegate(forecast: state.forecast),
              pinned: true,
            ),
            ...switch (state.status) {
              ForecastStatus.empty => [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Text(
                        'Please select a location',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurface.withOpacity(.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ForecastStatus.loading => [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(60),
                      child:
                          Center(child: CircularProgressIndicator.adaptive()),
                    ),
                  )
                ],
              ForecastStatus.ok => [
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        WindSpeedCard(windSpeed: state.forecast.windSpeed),
                        WindDirectionCard(
                            windDirection: state.forecast.windDirection),
                        PressureCard(pressure: state.forecast.pressure),
                        UvIndexCard(uvIndex: state.forecast.uvIndex),
                      ],
                    ),
                  ),
                  if (state.forecast.hourlyForecast != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: HourlyForecastCard(
                          hourlyForecast: state.forecast.hourlyForecast!,
                        ),
                      ),
                    ),
                  if (state.forecast.dailyForecast != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: DailyForecastCard(
                            dailyForecast: state.forecast.dailyForecast!),
                      ),
                    ),
                  if (state.forecast.hourlyForecast != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: RainChanceCard(
                            hourlyForecast: state.forecast.hourlyForecast!),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: SourceInformation(
                        lastUpdated: state.forecast.lastUpdated,
                        weatherSource: state.forecast.weatherSource,
                      ),
                    ),
                  )
                ],
              ForecastStatus.error => [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Text(
                        state.error,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: colorScheme.error.withOpacity(.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ]
            },
          ],
        ),
      ),
    );
  }
}
