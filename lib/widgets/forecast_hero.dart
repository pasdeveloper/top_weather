import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_utils.dart';
import 'package:top_weather/models/weather_data.dart';

class ForecastHero extends StatelessWidget {
  const ForecastHero(
    this.conditions, {
    super.key,
  });

  final Conditions conditions;

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
        AppImages.iconPathByName(conditions.icon),
        height: 150,
        width: 150,
      ),
    );
  }

  Column _currentInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bigTemperature(theme),
        if (conditions.description != null) _description(theme),
        const Spacer(),
        _temperatureSummary(theme),
        _date(theme),
      ],
    );
  }

  Text _date(ThemeData theme) {
    return Text(
      toDate(conditions.datetimeEpoch),
      style: theme.textTheme.bodyMedium!
          .copyWith(color: theme.colorScheme.onSurface.withOpacity(.7)),
    );
  }

  Row _temperatureSummary(ThemeData theme) {
    return Row(
      children: [
        Text(
          '${conditions.tempmin}°',
          style:
              theme.textTheme.headlineSmall!.copyWith(color: Colors.lightBlue),
        ),
        Text(
          ' / ',
          style: theme.textTheme.headlineSmall,
        ),
        Text(
          '${conditions.tempmax}°',
          style: theme.textTheme.headlineSmall!.copyWith(color: Colors.red),
        ),
        Text(
          ' Feels like ${conditions.feelslike}°',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }

  Text _description(ThemeData theme) {
    return Text(
      conditions.description!,
      style: theme.textTheme.bodyLarge,
    );
  }

  Text _bigTemperature(ThemeData theme) {
    return Text(
      '${conditions.temp}°',
      style:
          theme.textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
