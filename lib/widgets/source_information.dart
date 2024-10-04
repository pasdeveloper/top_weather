import 'package:flutter/material.dart';
import 'package:top_weather/constants/time_formatting.dart';
import 'package:top_weather/l10n/localizations_export.dart';

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
      AppLocalizations.of(context)!
          .lastUpdated(fullTimeFormatter.format(lastUpdated), weatherSource),
      style: textTheme.labelSmall!.copyWith(color: colorScheme.onSurface),
      textAlign: TextAlign.center,
    );
  }
}
