import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/widgets/daily_temperature_graph.dart';
import 'package:top_weather/widgets/day_forecast_expandable_card.dart';
import 'package:top_weather/widgets/forecast_card.dart';
import 'package:top_weather/widgets/forecast_card_icon.dart';
import 'package:top_weather/widgets/forecast_persistent_header_delegate.dart';
import 'package:top_weather/widgets/hourly_forecast_scrollable_row.dart';
import 'package:top_weather/widgets/rain_chance_scrollable_column.dart';
import 'package:top_weather/widgets/source_information.dart';
import 'package:top_weather/widgets/tab_bar_persistent_header_delegate.dart';

const double _gap = 8;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForecastCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> refreshForecast() async {
      final selectedLocation =
          context.read<SelectedLocationBloc>().state.selectedLocation;
      if (selectedLocation != null) {
        return context.read<ForecastCubit>().fetchForecast(selectedLocation);
      } else {
        context.read<ForecastCubit>().emptyForecast();
        return;
      }
    }

    return BlocListener<SelectedLocationBloc, SelectedLocationState>(
      listener: (context, selectedLocationState) {
        // chiama refreshForecast() attraverso RefreshIndicator
        _refreshIndicatorKey.currentState!.show();
      },
      child: Scaffold(
        body: RefreshIndicator.adaptive(
          key: _refreshIndicatorKey,
          onRefresh: refreshForecast,
          notificationPredicate: (notification) => notification.depth == 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  delegate: ForecastPersistentHeaderDelegate(
                    forecast: state.forecast,
                  ),
                  pinned: true,
                ),
              ),
              if (!state.forecast.empty)
                SliverPersistentHeader(
                  delegate: TabBarPersistentHeaderDelegate(
                      tabController: _tabController),
                  pinned: true,
                ),
            ],
            body: _getBody(state, colorScheme, _tabController),
          ),
        ),
      ),
    );
  }
}

Widget _getBody(
    ForecastState state, ColorScheme colorScheme, TabController tabController) {
  final status = state.status;

  if (status == ForecastStatus.empty) {
    return _centerPageMessage('Please select a location');
  }

  if (status == ForecastStatus.error) {
    return _centerPageMessage(state.error, color: colorScheme.error);
  }

  if (status == ForecastStatus.loading && state.forecast.empty) {
    return _centerPageMessage('Loading forecast...');
  }

  return TabBarView(
    controller: tabController,
    children: [
      _wrapWithOverlapAbsorber(widget: _todayForecastPage(state.forecast)),
      _wrapWithOverlapAbsorber(widget: _nextDaysForecastPage(state.forecast)),
    ],
  );
}

Builder _wrapWithOverlapAbsorber({required Widget widget}) {
  return Builder(
    builder: (context) => CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: widget,
        )
      ],
    ),
  );
}

Widget _centerPageMessage(String text, {Color? color}) {
  return Builder(builder: (context) {
    color = color ?? Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: color!.withOpacity(.5),
        ),
        // textAlign: TextAlign.center,
      ),
    );
  });
}

Widget _nextDaysForecastPage(Forecast forecast) {
  if (forecast.dailyForecast == null) {
    return _centerPageMessage('Not available');
  }

  final List<DayForecast> days = forecast.dailyForecast!.days;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        for (final dayForecast in days)
          DayForecastExpandableCard(
            dayForecast: dayForecast,
            key: ValueKey(dayForecast),
          ),
        SourceInformation(
          lastUpdated: forecast.createdAt,
          weatherSource: forecast.weatherSource,
        ),
      ],
    ),
  );
}

Widget _todayForecastPage(Forecast forecast) => Builder(builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ForecastCard(
                    title: 'Wind speed',
                    iconData: Icons.wind_power,
                    sideIcon: true,
                    child: Text(
                      '${forecast.windSpeed} km/h',
                      style: textTheme.bodyLarge!
                          .copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                ),
                Expanded(
                  child: ForecastCard(
                    title: 'Wind direction',
                    sideIcon: true,
                    customIcon: Transform.rotate(
                      angle: forecast.windDirection / 180 * pi,
                      child: const ForecastCardIcon(iconData: Icons.navigation),
                    ),
                    child: Text(
                      _degreesToDirection(forecast.windDirection),
                      style: textTheme.bodyLarge!
                          .copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ForecastCard(
                    title: 'Pressure',
                    iconData: Icons.waves,
                    sideIcon: true,
                    child: Text(
                      '${forecast.pressure} hpa',
                      style: textTheme.bodyLarge!
                          .copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                ),
                Expanded(
                  child: ForecastCard(
                      title: 'UV index',
                      iconData: Icons.wb_sunny,
                      sideIcon: true,
                      child: Text(
                        '${forecast.uvIndex}',
                        style: textTheme.bodyLarge!
                            .copyWith(color: colorScheme.onSurface),
                      )),
                )
              ],
            ),
            if (forecast.hourlyForecast != null)
              ForecastCard(
                title: 'Hourly forecast',
                iconData: Icons.schedule,
                child: HourlyForecastScrollableRow(
                    hourlyForecast: forecast.hourlyForecast!),
              ),
            if (forecast.dailyForecast != null)
              ForecastCard(
                title: 'Daily temperature',
                iconData: Icons.thermostat,
                child: DailyTemperatureGraph(
                    dailyForecast: forecast.dailyForecast!),
              ),
            if (forecast.hourlyForecast != null)
              ForecastCard(
                title: 'Rain chance',
                iconData: Icons.thunderstorm,
                child: SizedBox(
                  height: 180,
                  child: RainChanceScrollableColumn(
                      hourlyForecast: forecast.hourlyForecast!),
                ),
              ),
            SourceInformation(
              lastUpdated: forecast.createdAt,
              weatherSource: forecast.weatherSource,
            ),
          ],
        ),
      );
    });

String _degreesToDirection(double windDirection) {
  if (windDirection < 45) return 'North';
  if (windDirection < 90) return 'NorthEast';
  if (windDirection < 135) return 'East';
  if (windDirection < 180) return 'SouthEast';
  if (windDirection < 225) return 'South';
  if (windDirection < 270) return 'SouthWest';
  if (windDirection < 315) return 'West';
  if (windDirection < 360) return 'NorthWest';
  return 'North';
}
