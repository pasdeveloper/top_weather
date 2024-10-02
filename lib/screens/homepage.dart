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
import 'package:top_weather/widgets/tab_bar_persistent_header_delegate.dart';
import 'package:top_weather/widgets/uv_index_card.dart';
import 'package:top_weather/widgets/wind_direction_card.dart';
import 'package:top_weather/widgets/wind_speed_card.dart';

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
    return _centerPageMessage(
        'Please select a location', colorScheme.onSurface);
  }

  if (status == ForecastStatus.error) {
    return _centerPageMessage(state.error, colorScheme.error);
  }

  if (status == ForecastStatus.loading && state.forecast.empty) {
    return _centerPageMessage('Loading forecast...', colorScheme.onSurface);
  }

  return TabBarView(
    controller: tabController,
    children: [
      _wrapWithOverlapAbsorber(Column(
        children: _getForecastElements(state),
      )),
      _wrapWithOverlapAbsorber(const Text('Other tab')),
    ],
  );
}

Builder _wrapWithOverlapAbsorber(Widget widget) {
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

Widget _centerPageMessage(String text, Color color) {
  return Center(
    child: Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        color: color.withOpacity(.5),
      ),
      // textAlign: TextAlign.center,
    ),
  );
}

List<Widget> _getForecastElements(ForecastState state) => [
      Padding(
        padding:
            const EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
        child: Row(
          children: [
            Expanded(
              child: WindSpeedCard(windSpeed: state.forecast.windSpeed),
            ),
            const SizedBox(width: _gap),
            Expanded(
                child: WindDirectionCard(
                    windDirection: state.forecast.windDirection)),
          ],
        ),
      ),
      Padding(
        padding:
            const EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
        child: Row(
          children: [
            Expanded(
              child: PressureCard(pressure: state.forecast.pressure),
            ),
            const SizedBox(width: _gap),
            Expanded(
              child: UvIndexCard(uvIndex: state.forecast.uvIndex),
            ),
          ],
        ),
      ),
      if (state.forecast.hourlyForecast != null)
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
          child: HourlyForecastCard(
            hourlyForecast: state.forecast.hourlyForecast!,
          ),
        ),
      if (state.forecast.dailyForecast != null)
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
          child:
              DailyForecastCard(dailyForecast: state.forecast.dailyForecast!),
        ),
      if (state.forecast.hourlyForecast != null)
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
          child: RainChanceCard(hourlyForecast: state.forecast.hourlyForecast!),
        ),
      Padding(
        padding:
            const EdgeInsets.symmetric(vertical: _gap / 2, horizontal: _gap),
        child: SourceInformation(
          lastUpdated: state.forecast.createdAt,
          weatherSource: state.forecast.weatherSource,
        ),
      ),
    ];
