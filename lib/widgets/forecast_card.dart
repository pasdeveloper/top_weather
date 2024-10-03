import 'package:flutter/material.dart';
import 'package:top_weather/widgets/forecast_card_icon.dart';

class ForecastCard extends StatelessWidget {
  ForecastCard({
    super.key,
    required this.title,
    IconData? iconData,
    Widget? customIcon,
    this.sideIcon = false,
    required this.child,
  })  : assert(customIcon != null || iconData != null),
        icon = customIcon ?? ForecastCardIcon(iconData: iconData!);

  final Widget child;
  final String title;
  final Widget icon;
  final bool sideIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                icon,
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall!
                          .copyWith(color: colorScheme.onSurface),
                    ),
                    if (sideIcon) ...[const SizedBox(height: 5), child]
                  ],
                )
              ],
            ),
            if (!sideIcon) ...[
              const SizedBox(height: 5),
              child,
            ]
          ],
        ),
      ),
    );
  }
}
