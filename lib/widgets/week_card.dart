import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_utils.dart';
import 'package:top_weather/models/weather_forecast.dart';
import 'package:top_weather/widgets/precipitation_probability.dart';

class WeekCard extends StatelessWidget {
  const WeekCard({
    required this.dailyForecast,
    super.key,
  });

  final DailyForecast dailyForecast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: dailyForecast.days
                .map(
                  (dayForecast) => _dayTileForecast(dayForecast, context),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _dayTileForecast(DayForecast dayForecast, BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            dayNameFormatter.format(dayForecast.datetime),
            style: theme.textTheme.titleLarge!
                .copyWith(color: theme.colorScheme.onPrimaryContainer),
          ),
          const Spacer(),
          if (dayForecast.precipitationProbability != null)
            PrecipitationProbability(dayForecast.precipitationProbability!),
          const SizedBox(
            width: 10,
          ),
          SvgPicture.asset(
            AppImages.iconPathByName(dayForecast.icon),
            height: 30,
            width: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${dayForecast.minTemperature}°',
            style: theme.textTheme.bodyLarge!.copyWith(color: Colors.lightBlue),
          ),
          Text(
            ' / ',
            style: theme.textTheme.bodyLarge,
          ),
          Text(
            '${dayForecast.maxTemperature}°',
            style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
