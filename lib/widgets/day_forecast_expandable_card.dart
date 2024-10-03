import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/constants/date_formatting.dart';
import 'package:top_weather/constants/weather_icons.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/widgets/hourly_forecast_scrollable_row.dart';

class DayForecastExpandableCard extends StatefulWidget {
  const DayForecastExpandableCard({
    super.key,
    required this.dayForecast,
  });

  final DayForecast dayForecast;

  @override
  State<DayForecastExpandableCard> createState() => _DayForecastCardState();
}

class _DayForecastCardState extends State<DayForecastExpandableCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: colorScheme.secondaryContainer,
      clipBehavior: Clip.hardEdge,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            InkWell(
              onTap: widget.dayForecast.hourlyForecast != null
                  ? () => setState(() => _expanded = !_expanded)
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _daySummary(textTheme, colorScheme),
              ),
            ),
            if (widget.dayForecast.hourlyForecast != null)
              AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      Divider(
                        height: 1,
                        thickness: 0,
                        indent: 15,
                        endIndent: 15,
                        color: colorScheme.onSecondaryContainer.withOpacity(.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: HourlyForecastScrollableRow(
                            hourlyForecast: widget.dayForecast.hourlyForecast!),
                      ),
                    ],
                  ),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200))
          ],
        ),
      ),
    );
  }

  IntrinsicHeight _daySummary(TextTheme textTheme, ColorScheme colorScheme) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  dateFormatter.format(widget.dayForecast.datetime),
                  style: textTheme.titleSmall!
                      .copyWith(color: colorScheme.onSecondaryContainer),
                ),
                Text(
                  widget.dayForecast.description,
                  style: textTheme.bodySmall!
                      .copyWith(color: colorScheme.onSecondaryContainer),
                )
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '▼ ${widget.dayForecast.minTemperature}°\n▲ ${widget.dayForecast.maxTemperature}°',
                style: textTheme.titleSmall!
                    .copyWith(color: colorScheme.onSecondaryContainer),
              ),
              VerticalDivider(
                width: 20,
                thickness: 1,
                endIndent: 8,
                indent: 8,
                color: colorScheme.onSecondaryContainer,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  WeatherIcons.iconPathByName(widget.dayForecast.icon),
                  width: 50,
                ),
              ),
            ],
          ),
          if (widget.dayForecast.hourlyForecast != null)
            AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _expanded ? .5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}
