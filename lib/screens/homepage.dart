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

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final double _gap = 8;

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
              SliverPersistentHeader(
                delegate: ForecastPersistentHeaderDelegate(
                    forecast: state.forecast, tabController: _tabController),
                pinned: true,
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _todaycontent(state, colorScheme, _tabController),
                const SingleChildScrollView(child: Text('Other tab')),
                // const Text('Other tab'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _todaycontent(ForecastState state, ColorScheme colorScheme,
      TabController tabController) {
    final status = state.status;

    if (status == ForecastStatus.empty) {
      return Center(
        child: Text(
          'Please select a location',
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withOpacity(.5),
          ),
          // textAlign: TextAlign.center,
        ),
      );
    }

    if (status == ForecastStatus.error) {
      return Padding(
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
      );
    }

    if (status == ForecastStatus.loading && state.forecast.empty) {
      return Center(
        child: Text(
          'Loading forecast...',
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withOpacity(.5),
          ),
          // textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
            child: Row(
              children: [
                Expanded(
                  child: WindSpeedCard(windSpeed: state.forecast.windSpeed),
                ),
                SizedBox(width: _gap),
                Expanded(
                    child: WindDirectionCard(
                        windDirection: state.forecast.windDirection)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
            child: Row(
              children: [
                Expanded(
                  child: PressureCard(pressure: state.forecast.pressure),
                ),
                SizedBox(width: _gap),
                Expanded(
                  child: UvIndexCard(uvIndex: state.forecast.uvIndex),
                ),
              ],
            ),
          ),
          if (state.forecast.hourlyForecast != null)
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
              child: HourlyForecastCard(
                hourlyForecast: state.forecast.hourlyForecast!,
              ),
            ),
          if (state.forecast.dailyForecast != null)
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
              child: DailyForecastCard(
                  dailyForecast: state.forecast.dailyForecast!),
            ),
          if (state.forecast.hourlyForecast != null)
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
              child: RainChanceCard(
                  hourlyForecast: state.forecast.hourlyForecast!),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
            child: SourceInformation(
              lastUpdated: state.forecast.createdAt,
              weatherSource: state.forecast.weatherSource,
            ),
          )
        ],
      ),
    );
  }
}
