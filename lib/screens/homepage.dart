import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/bloc/forecast/forecast_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/core/locale_date_formatting.dart';
import 'package:top_weather/l10n/localizations_export.dart';
import 'package:top_weather/models/forecast/daily_forecast.dart';
import 'package:top_weather/models/forecast/forecast.dart';
import 'package:top_weather/widgets/daily_temperature_graph.dart';
import 'package:top_weather/widgets/day_forecast_expandable_card.dart';
import 'package:top_weather/widgets/forecast_card.dart';
import 'package:top_weather/widgets/forecast_card_icon.dart';
import 'package:top_weather/widgets/forecast_persistent_header_delegate.dart';
import 'package:top_weather/widgets/hourly_forecast_scrollable_row.dart';
import 'package:top_weather/widgets/rain_chance_scrollable_column.dart';
import 'package:top_weather/widgets/source_information.dart';
import 'package:top_weather/widgets/tab_bar_persistent_header_delegate.dart';

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
            body: _getBody(state, context, _tabController),
          ),
        ),
      ),
    );
  }
}

Widget _getBody(
    ForecastState state, BuildContext context, TabController tabController) {
  final colorScheme = Theme.of(context).colorScheme;
  final status = state.status;

  if (status == ForecastStatus.empty) {
    return _centerPageMessage(AppLocalizations.of(context)!.emptyForecast);
  }

  if (status == ForecastStatus.error) {
    return _centerPageMessage(state.error, color: colorScheme.error);
  }

  if (status == ForecastStatus.loading && state.forecast.empty) {
    return _centerPageMessage(AppLocalizations.of(context)!.loadingForecast);
  }

  return TabBarView(
    controller: tabController,
    children: [
      _wrapWithOverlapAbsorber(widget: _todayTabContent(state.forecast)),
      _wrapWithOverlapAbsorber(widget: _nextDaysTabContent(state.forecast)),
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

Widget _nextDaysTabContent(Forecast forecast) {
  if (forecast.dailyForecast == null) {
    return const SizedBox.shrink();
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

Widget _todayTabContent(Forecast forecast) => Builder(builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      final dateFormatting =
          LocaleDateFormatting(AppLocalizations.of(context)!.localeName);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ForecastCard(
                    title: AppLocalizations.of(context)!.windSpeed,
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
                    title: AppLocalizations.of(context)!.windDirection,
                    sideIcon: true,
                    customIcon: Transform.rotate(
                      angle: forecast.windDirection / 180 * pi,
                      child: const ForecastCardIcon(iconData: Icons.navigation),
                    ),
                    child: Text(
                      _degreesToDirection(forecast.windDirection, context),
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
                    title: AppLocalizations.of(context)!.pressure,
                    iconData: Icons.waves,
                    sideIcon: true,
                    child: Text(
                      '${forecast.pressure.toDouble()} hpa',
                      style: textTheme.bodyLarge!
                          .copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                ),
                Expanded(
                  child: ForecastCard(
                      title: AppLocalizations.of(context)!.uvIndex,
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
                title: AppLocalizations.of(context)!.hourlyForecast,
                iconData: Icons.schedule,
                child: HourlyForecastScrollableRow(
                    hourlyForecast: forecast.hourlyForecast!),
              ),
            if (forecast.dailyForecast != null)
              ForecastCard(
                title: AppLocalizations.of(context)!.dailyTemperature,
                iconData: Icons.thermostat,
                child: DailyTemperatureGraph(
                    dailyForecast: forecast.dailyForecast!),
              ),
            if (forecast.hourlyForecast != null)
              ForecastCard(
                title: AppLocalizations.of(context)!.rainChance,
                iconData: Icons.thunderstorm_outlined,
                child: SizedBox(
                  height: 180,
                  child: RainChanceScrollableColumn(
                      hourlyForecast: forecast.hourlyForecast!),
                ),
              ),
            Row(
              children: [
                forecast.sunrise != null
                    ? Expanded(
                        child: ForecastCard(
                          title: AppLocalizations.of(context)!.sunrise,
                          iconData: Icons.wb_sunny,
                          sideIcon: true,
                          child: Text(
                            dateFormatting.timeFormatter
                                .format(forecast.sunrise!),
                            style: textTheme.bodyLarge!
                                .copyWith(color: colorScheme.onSurface),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                forecast.sunset != null
                    ? Expanded(
                        child: ForecastCard(
                          title: AppLocalizations.of(context)!.sunset,
                          iconData: Icons.wb_twilight,
                          sideIcon: true,
                          child: Text(
                            dateFormatting.timeFormatter
                                .format(forecast.sunset!),
                            style: textTheme.bodyLarge!
                                .copyWith(color: colorScheme.onSurface),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            SourceInformation(
              lastUpdated: forecast.createdAt,
              weatherSource: forecast.weatherSource,
            ),
          ],
        ),
      );
    });

String _degreesToDirection(double windDirection, BuildContext context) {
  if (windDirection < 45) return AppLocalizations.of(context)!.north;
  if (windDirection < 90) return AppLocalizations.of(context)!.northEast;
  if (windDirection < 135) return AppLocalizations.of(context)!.east;
  if (windDirection < 180) return AppLocalizations.of(context)!.southEast;
  if (windDirection < 225) return AppLocalizations.of(context)!.south;
  if (windDirection < 270) return AppLocalizations.of(context)!.southWest;
  if (windDirection < 315) return AppLocalizations.of(context)!.west;
  if (windDirection < 360) return AppLocalizations.of(context)!.northWest;
  return AppLocalizations.of(context)!.north;
}
