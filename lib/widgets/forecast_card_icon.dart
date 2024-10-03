import 'package:flutter/material.dart';

class ForecastCardIcon extends StatelessWidget {
  const ForecastCardIcon({super.key, required this.iconData});
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: colorScheme.surface),
      width: 35,
      height: 35,
      child: Icon(
        iconData,
        color: colorScheme.onSurface,
        size: 20,
      ),
    );
  }
}
