import 'dart:math';

import 'package:flutter/material.dart';
import 'package:top_weather/widgets/card_icon.dart';

class WindDirectionCard extends StatelessWidget {
  const WindDirectionCard({super.key, required this.windDirection});

  final double windDirection;

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
            Transform.rotate(
              angle: windDirection / 180 * pi,
              child: cardIconFrom(Icons.navigation_rounded, colorScheme),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wind direction',
                  style: textTheme.titleSmall!
                      .copyWith(color: colorScheme.onSurface),
                ),
                Text(
                  _degreesToDirection(windDirection),
                  style: textTheme.bodyLarge!
                      .copyWith(color: colorScheme.onSurface),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  String _degreesToDirection(double windDirection) {
    if (windDirection < 45) return 'North';
    if (windDirection < 90) return 'NorthEast';
    if (windDirection < 135) return 'East';
    if (windDirection < 180) return 'SouthEast';
    if (windDirection < 225) return 'South';
    if (windDirection < 270) return 'SouthWest';
    if (windDirection < 315) return 'West';
    if (windDirection < 360) return 'NorthWest';
    return 'North';
  }
}
