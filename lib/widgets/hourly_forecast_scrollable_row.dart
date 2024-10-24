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
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        prototypeItem: _hourForecastTile(hourlyForecast.hours[0],
            textTheme: textTheme, colorScheme: colorScheme),
        itemCount: hourlyForecast.hours.length,
        itemBuilder: (context, index) => _hourForecastTile(
            hourlyForecast.hours[index],
            textTheme: textTheme,
            colorScheme: colorScheme),
      ),
    );
  }

  Widget _hourForecastTile(HourForecast hourForecast,
          {required TextTheme textTheme, required ColorScheme colorScheme}) =>
      Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${hourForecast.temperatureRound}°',
              style:
                  textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
            ),
            ForecastIconWidget(
              icon: hourForecast.icon,
              width: 30,
              height: 30,
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
