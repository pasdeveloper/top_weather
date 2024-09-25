import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_utils.dart';
import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/widgets/precipitation_probability.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    super.key,
    required this.hourlyForecast,
  });

  final HourlyForecast hourlyForecast;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: hourlyForecast.hours
                .map(
                  (hourForecast) => _hourForecastTile(hourForecast, context),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget _hourForecastTile(HourForecast hourForecast, BuildContext context) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        Text(
          timeFormatter.format(hourForecast.datetime),
          style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(.7)),
        ),
        const SizedBox(
          height: 10,
        ),
        SvgPicture.asset(
          AppImages.iconPathByName(hourForecast.icon),
          height: 30,
          width: 30,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '${hourForecast.temperature}°',
          style: theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(
          height: 5,
        ),
        if (hourForecast.precipitationProbability != null)
          PrecipitationProbability(hourForecast.precipitationProbability!)
      ],
    ),
  );
}
