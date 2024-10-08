import 'package:flutter/material.dart';
import 'package:top_weather/constants/time_formatting.dart';
import 'package:top_weather/models/forecast/hourly_forecast.dart';
import 'package:top_weather/widgets/forecast_icon.dart';

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
              '${hourForecast.temperatureRound}°',
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(
              height: 8,
            ),
            ForecastIconWidget(
              icon: hourForecast.icon,
              width: 30,
              height: 30,
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
