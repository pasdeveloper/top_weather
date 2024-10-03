import 'package:flutter/material.dart';
import 'package:top_weather/constants/date_formatting.dart';
import 'package:top_weather/models/forecast.dart';

class RainChanceScrollableColumn extends StatelessWidget {
  const RainChanceScrollableColumn({
    super.key,
    required this.hourlyForecast,
  });

  final HourlyForecast hourlyForecast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        children: hourlyForecast.hours
            .map((hourForecast) =>
                _rainChanceTile(colorScheme, textTheme, hourForecast))
            .toList(),
      ),
    );
  }

  Widget _rainChanceTile(
      ColorScheme colorScheme, TextTheme textTheme, HourForecast hourForecast) {
    return SizedBox(
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              timeFormatter.format(hourForecast.datetime),
              textAlign: TextAlign.end,
              style:
                  textTheme.bodyMedium!.copyWith(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(50),
              minHeight: 22,
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              value: hourForecast.precipitationProbability! / 100,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            '${hourForecast.precipitationProbability!}%',
            textAlign: TextAlign.end,
            style:
                textTheme.labelMedium!.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }
}
