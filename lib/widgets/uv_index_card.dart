import 'package:flutter/material.dart';
import 'package:top_weather/widgets/card_icon.dart';

class UvIndexCard extends StatelessWidget {
  const UvIndexCard({
    super.key,
    required this.uvIndex,
  });

  final double uvIndex;

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
            cardIconFrom(Icons.wb_sunny, colorScheme),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'UV index',
                  style: textTheme.titleSmall!
                      .copyWith(color: colorScheme.onSurface),
                ),
                Text(
                  '$uvIndex',
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
