import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/widgets/daily_forecast_card.dart';
import 'package:top_weather/widgets/forecast_persistent_header_delegate.dart';
import 'package:top_weather/widgets/hourly_forecast_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForecastCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;
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
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  if (state.forecast.hourlyForecast != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: HourlyForecastCard(
                        hourlyForecast: state.forecast.hourlyForecast!,
                      ),
                    ),
                  if (state.forecast.dailyForecast != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: DailyForecastCard(
                          dailyForecast: state.forecast.dailyForecast!),
                    ),
                ],
              ),
            ),
          ],
        ),

        // appBar: AppBar(
        //   // backgroundColor: Colors.transparent,
        //   // systemOverlayStyle: SystemUiOverlayStyle.dark,
        //   title: Text(context
        //           .watch<SelectedLocationBloc>()
        //           .state
        //           .selectedLocation
        //           ?.name ??
        //       'Top Weather'),
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           final themeCubit = context.read<ThemeCubit>();
        //           final currentTheme = themeCubit.state.themeMode;
        //           themeCubit.setTheme(currentTheme == ThemeMode.light
        //               ? ThemeMode.dark
        //               : ThemeMode.light);
        //         },
        //         icon: const Icon(Icons.brightness_6)),
        //     IconButton(
        //         onPressed: () => _openLocations(context),
        //         icon: const Icon(Icons.list)),
        //   ],
        // ),
        // body: switch (state.status) {
        //   ForecastStatus.empty => _emptyWeather(context),
        //   ForecastStatus.loading => _loading(),
        //   ForecastStatus.ok => _body(context, state.forecast),
        //   ForecastStatus.error => state.forecast.empty
        //       ? _emptyWeather(context)
        //       : _body(context, state.forecast),
        // },
      ),
    );
  }
}
