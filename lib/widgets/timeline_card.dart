import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_utils.dart';
import 'package:top_weather/models/weather_data.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard(
    this.hours, {
    super.key,
  });

  final List<Conditions> hours;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hours
                .map(
                  (hourConditions) =>
                      _hourTileForecast(hourConditions, context),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget _hourTileForecast(Conditions conditions, BuildContext context) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        Text(
          toTime(conditions.datetimeEpoch),
          style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(.7)),
        ),
        const SizedBox(
          height: 10,
        ),
        SvgPicture.asset(
          AppImages.iconPathByName(conditions.icon),
          height: 30,
          width: 30,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '${conditions.temp}°',
          style: theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop,
              size: 12,
              color: theme.colorScheme.onPrimaryContainer.withOpacity(.7),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              '${conditions.precipprob.round()}%',
              style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(.7)),
            )
          ],
        )
      ],
    ),
  );
}
