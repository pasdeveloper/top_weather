import 'package:flutter/material.dart';
import 'package:top_weather/widgets/card_icon.dart';

class WindSpeedCard extends StatelessWidget {
  const WindSpeedCard({
    super.key,
    required this.windSpeed,
  });
  final double windSpeed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            cardIconFrom(Icons.wind_power, colorScheme),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wind speed',
                  style: textTheme.titleSmall!
                      .copyWith(color: colorScheme.onSurface),
                ),
                Text(
                  '$windSpeed km/h',
                  style: textTheme.titleMedium!
                      .copyWith(color: colorScheme.onSurface),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
