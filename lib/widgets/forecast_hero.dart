import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_formatting.dart';
import 'package:top_weather/models/weather_forecast.dart';

class ForecastHero extends StatelessWidget {
  const ForecastHero({
    super.key,
    required this.forecast,
  });

  final WeatherForecast forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          _backgroundIcon(),
          _currentInfo(context),
        ],
      ),
    );
  }

  Positioned _backgroundIcon() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: SvgPicture.asset(
        AppImages.iconPathByName(forecast.icon),
        height: 160,
      ),
    );
  }

  Column _currentInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bigTemperature(theme),
        _description(theme),
        const Spacer(),
        _temperatureSummary(theme),
        _date(theme),
      ],
    );
  }

  Text _date(ThemeData theme) => Text(
        'Last updated: ${timeFormatter.format(forecast.lastUpdated)}',
        style: theme.textTheme.bodyMedium!
            .copyWith(color: theme.colorScheme.onSurface.withOpacity(.7)),
      );

  // TODO: fallo meglio
  Row _temperatureSummary(ThemeData theme) => Row(
        children: [
          Text(
            '${forecast.todayMinTemperature}°',
            style: theme.textTheme.headlineSmall!
                .copyWith(color: Colors.lightBlue),
          ),
          Text(
            ' / ',
            style: theme.textTheme.headlineSmall,
          ),
          Text(
            '${forecast.todayMaxTemperature}°',
            style: theme.textTheme.headlineSmall!.copyWith(color: Colors.red),
          ),
          Text(
            ' Feels like ${forecast.feelsLikeTemperature}°',
            style: theme.textTheme.headlineSmall,
          ),
        ],
      );

  Text _description(ThemeData theme) => Text(
        forecast.description,
        style: theme.textTheme.bodyLarge,
      );

  Text _bigTemperature(ThemeData theme) => Text(
        '${forecast.nowTemperature}°',
        style:
            theme.textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
      );
}
