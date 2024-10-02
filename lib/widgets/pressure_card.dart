import 'package:flutter/material.dart';
import 'package:top_weather/widgets/card_icon.dart';

class PressureCard extends StatelessWidget {
  const PressureCard({
    super.key,
    required this.pressure,
  });

  final double pressure;

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
            cardIconFrom(Icons.waves, colorScheme),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pressure',
                    style: textTheme.titleSmall!
                        .copyWith(color: colorScheme.onSurface),
                  ),
                  Text(
                    '$pressure hpa',
                    style: textTheme.bodyLarge!
                        .copyWith(color: colorScheme.onSurface),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
