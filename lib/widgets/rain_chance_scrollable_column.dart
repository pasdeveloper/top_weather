import 'package:flutter/material.dart';
import 'package:top_weather/constants/time_formatting.dart';
import 'package:top_weather/models/forecast/hourly_forecast.dart';

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
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: hourlyForecast.hours.length,
      itemBuilder: (context, index) =>
          _rainChanceTile(colorScheme, textTheme, hourlyForecast.hours[index]),
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
