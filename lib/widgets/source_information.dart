import 'package:flutter/material.dart';
import 'package:top_weather/constants/date_formatting.dart';

class SourceInformation extends StatelessWidget {
  const SourceInformation({
    super.key,
    required this.lastUpdated,
    required this.weatherSource,
  });

  final DateTime lastUpdated;
  final String weatherSource;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Text(
      'Last updated at ${timeFormatter.format(lastUpdated)} from $weatherSource',
      style: textTheme.labelSmall!.copyWith(color: colorScheme.onSurface),
      textAlign: TextAlign.center,
    );
  }
}
