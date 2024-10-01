import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/bloc/selected_location/selected_location_bloc.dart';
import 'package:top_weather/bloc/theme/theme_cubit.dart';
import 'package:top_weather/constants/app_images.dart';
import 'package:top_weather/constants/assets.dart';
import 'package:top_weather/constants/date_formatting.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/models/location.dart';
import 'package:top_weather/screens/locations.dart';

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

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final double collapsePercentage =
        min(shrinkOffset / (maxExtent - minExtent), 1);
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(33), bottomRight: Radius.circular(33)),
      ),
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              // TODO: immagine dinamica
              Assets.assetsImagesWeatherEveningClear1,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(collapsePercentage),
                  BlendMode.dstOut),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.black26),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _appBar(context, collapsePercentage),
              if (!forecast.empty)
                _temperature(textTheme, colorScheme, collapsePercentage),
              SizedBox(
                height: (1 - collapsePercentage) * 60,
              )
            ],
          ),
          if (!forecast.empty)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: _descriptions(textTheme, collapsePercentage),
            ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context, double collapsePercentage) {
    final textColor = collapsePercentage > .3
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Colors.white;
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        context.watch<SelectedLocationBloc>().state.selectedLocation?.name ??
            'Top Weather',
        style: TextStyle(color: textColor),
      ),
      actions: [
        IconButton(
            onPressed: () {
              final themeCubit = context.read<ThemeCubit>();
              final currentTheme = themeCubit.state.themeMode;
              themeCubit.setTheme(currentTheme == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light);
            },
            icon: Icon(
              Icons.brightness_6,
              color: textColor,
            )),
        IconButton(
            onPressed: () => _openLocations(context),
            icon: Icon(
              Icons.list,
              color: textColor,
            )),
      ],
    );
  }

  Widget _temperature(
      TextTheme textTheme, ColorScheme colorScheme, double collapsePercentage) {
    final textColor =
        collapsePercentage > .3 ? colorScheme.onPrimaryContainer : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Text(
                '${forecast.nowTemperature}°',
                style: textTheme.displayLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: textColor),
              ),
              Text(
                'Feels like ${forecast.feelsLikeTemperature}°',
                style: textTheme.bodyLarge!.copyWith(color: textColor),
              ),
            ],
          ),
          Column(
            children: [
              if (forecast.icon != null)
                SvgPicture.asset(
                  AppImages.iconPathByName(forecast.icon!),
                  height: max(50, (1 - collapsePercentage) * 120),
                ),
              const SizedBox(
                height: 10,
              ),
              Text(
                forecast.description,
                style: textTheme.bodyLarge!.copyWith(color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descriptions(TextTheme textTheme, double collapsePercentage) {
    final color = Colors.white.withOpacity(1 - collapsePercentage);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            dateFormatter.format(forecast.lastUpdated),
            style: textTheme.bodyLarge!.copyWith(color: color),
          ),
          Text(
            '▼ ${forecast.todayMinTemperature}°\n▲ ${forecast.todayMaxTemperature}°',
            style: textTheme.bodyLarge!
                .copyWith(color: color, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 220;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
