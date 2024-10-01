import 'package:flutter/material.dart';
import 'package:top_weather/constants/date_formatting.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/widgets/card_icon.dart';

class RainChanceCard extends StatelessWidget {
  const RainChanceCard({
    super.key,
    required this.hourlyForecast,
  });

  final HourlyForecast hourlyForecast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                cardIconFrom(Icons.thunderstorm, colorScheme),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Chance of rain',
                  style: textTheme.titleSmall!
                      .copyWith(color: colorScheme.onSurface),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            AspectRatio(
                aspectRatio: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: hourlyForecast.hours
                        .where((hourForecast) => !hourForecast.sunriseSunset)
                        .map((hourForecast) => _rainChanceTile(
                            colorScheme, textTheme, hourForecast))
                        .toList(),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _rainChanceTile(
      ColorScheme colorScheme, TextTheme textTheme, HourForecast hourForecast) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              timeFormatter.format(hourForecast.datetime),
              textAlign: TextAlign.end,
              style:
                  textTheme.titleSmall!.copyWith(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(50),
              minHeight: 25,
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
            style: textTheme.titleSmall!.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
