import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/constants/date_formatting.dart';
import 'package:top_weather/constants/weather_icons.dart';
import 'package:top_weather/models/forecast.dart';

class HourlyForecastScrollableRow extends StatelessWidget {
  const HourlyForecastScrollableRow({
    super.key,
    required this.hourlyForecast,
  });

  final HourlyForecast hourlyForecast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: hourlyForecast.hours
            .map(
              (hourForecast) => _hourForecastTile(hourForecast,
                  textTheme: textTheme, colorScheme: colorScheme),
            )
            .toList(),
      ),
    );
  }

  Widget _hourForecastTile(HourForecast hourForecast,
          {required TextTheme textTheme, required ColorScheme colorScheme}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          children: [
            Text(
              hourForecast.sunriseSunset
                  ? hourForecast.description
                  : '${hourForecast.temperatureRound}°',
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(
              height: 8,
            ),
            SvgPicture.asset(
              WeatherIcons.iconPathByName(hourForecast.icon),
              height: 30,
              width: 30,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              timeFormatter.format(hourForecast.datetime),
              style:
                  textTheme.labelMedium!.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
      );
}
