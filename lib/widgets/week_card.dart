import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_utils.dart';
import 'package:top_weather/models/weather_data.dart';
import 'package:top_weather/widgets/precipitation_probability.dart';

class WeekCard extends StatelessWidget {
  const WeekCard(
    this.days, {
    super.key,
  });

  final List<Conditions> days;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: days
                .map(
                  (dayCondition) => _dayTileForecast(dayCondition, context),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _dayTileForecast(Conditions conditions, BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            toDayName(conditions.datetimeEpoch),
            style: theme.textTheme.titleLarge!
                .copyWith(color: theme.colorScheme.onPrimaryContainer),
          ),
          const Spacer(),
          PrecipitationProbability(conditions.precipprob.round()),
          const SizedBox(
            width: 10,
          ),
          SvgPicture.asset(
            AppImages.iconPathByName(conditions.icon),
            height: 30,
            width: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${conditions.tempmin}°',
            style: theme.textTheme.bodyLarge!.copyWith(color: Colors.lightBlue),
          ),
          Text(
            ' / ',
            style: theme.textTheme.bodyLarge,
          ),
          Text(
            '${conditions.tempmax}°',
            style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
