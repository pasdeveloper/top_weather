import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/bloc/header/header_cubit.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/bloc/theme/theme_cubit.dart';
import 'package:top_weather/core/locale_date_formatting.dart';
import 'package:top_weather/l10n/localizations_export.dart';
import 'package:top_weather/models/forecast/forecast.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/screens/locations.dart';
import 'package:top_weather/widgets/forecast_icon.dart';

class ForecastPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Forecast forecast;

  ForecastPersistentHeaderDelegate({required this.forecast});

  void _openLocations(BuildContext context) async {
    Navigator.push<Location>(
        context,
        MaterialPageRoute(
          builder: (context) => const Locations(),
        ));
  }

  final double _descriptionContainerHeight = 80;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colorScheme = Theme.of(context).colorScheme;
    final double collapsePercentage =
        min(shrinkOffset / (maxExtent - minExtent), 1);

    context.read<HeaderCubit>().setCollapsed(collapsePercentage == 1);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(33 * (1 - collapsePercentage)),
            bottomRight: Radius.circular(33 * (1 - collapsePercentage))),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              forecast.background,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(collapsePercentage),
                  BlendMode.dstOut),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color.lerp(
                    Colors.black38, Colors.transparent, collapsePercentage)),
          ),
          if (!forecast.empty)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: _descriptions(context, collapsePercentage),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _appBar(context, collapsePercentage),
              if (!forecast.empty)
                Expanded(child: _temperature(context, collapsePercentage)),
              SizedBox(
                height: (1 - collapsePercentage) * _descriptionContainerHeight,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context, double collapsePercentage) {
    final textColor = Color.lerp(Colors.white,
        Theme.of(context).colorScheme.onPrimaryContainer, collapsePercentage);

    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        context.watch<SelectedLocationBloc>().state.selectedLocation?.name ??
            'Top Weather',
        style:
            Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor),
      ),
      actions: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                final nextTheme = switch (state.themeMode) {
                  ThemeMode.system => ThemeMode.light,
                  ThemeMode.light => ThemeMode.dark,
                  ThemeMode.dark => ThemeMode.system,
                };

                context.read<ThemeCubit>().setTheme(nextTheme);
              },
              icon: Icon(
                switch (state.themeMode) {
                  ThemeMode.system => Icons.brightness_auto,
                  ThemeMode.light => Icons.brightness_5,
                  ThemeMode.dark => Icons.brightness_4,
                },
                color: textColor,
              ),
            );
          },
        ),
        IconButton(
            onPressed: () => _openLocations(context),
            icon: Icon(
              Icons.list,
              color: textColor,
            )),
      ],
    );
  }

  Widget _temperature(BuildContext context, double collapsePercentage) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = Color.lerp(
        Colors.white, colorScheme.onPrimaryContainer, collapsePercentage);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            // flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${forecast.nowTemperature}°',
                  style: textTheme.displayLarge!
                      .copyWith(fontWeight: FontWeight.bold, color: textColor),
                ),
                Text(
                  AppLocalizations.of(context)!
                      .feelsLikeTemperature(forecast.feelsLikeTemperature),
                  style: textTheme.titleMedium!.copyWith(color: textColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            // flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => ForecastIconWidget(
                        icon: forecast.icon,
                        height: min(
                            constraints.maxWidth * .7, constraints.maxHeight),
                        alignment: Alignment.bottomRight),
                  ),
                ),
                Text(
                  forecast.description,
                  style: textTheme.titleMedium!.copyWith(color: textColor),
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptions(BuildContext context, double collapsePercentage) {
    final textTheme = Theme.of(context).textTheme;
    final dateFormatting =
        LocaleDateFormatting(AppLocalizations.of(context)!.localeName);
    final color = Colors.white.withOpacity(1 - collapsePercentage);

    return Container(
      height: _descriptionContainerHeight,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            dateFormatting.dateFormatter.format(forecast.weatherDataDatetime),
            style: textTheme.titleMedium!.copyWith(color: color),
          ),
          Text(
            '▼ ${forecast.todayMinTemperature}°\n▲ ${forecast.todayMaxTemperature}°',
            style: textTheme.titleMedium!
                .copyWith(color: color, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 380;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
