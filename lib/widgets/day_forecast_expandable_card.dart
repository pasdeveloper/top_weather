import 'package:flutter/material.dart';
import 'package:top_weather/core/locale_date_formatting.dart';
import 'package:top_weather/l10n/localizations_export.dart';
import 'package:top_weather/models/forecast.dart';
import 'package:top_weather/widgets/forecast_icon.dart';
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: colorScheme.secondaryContainer,
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          InkWell(
            onTap: widget.dayForecast.hourlyForecast != null
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _daySummary(context),
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
                duration: const Duration(milliseconds: 100))
        ],
      ),
    );
  }

  IntrinsicHeight _daySummary(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormatting =
        LocaleDateFormatting(AppLocalizations.of(context)!.localeName);
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
                  dateFormatting.dateFormatter
                      .format(widget.dayForecast.datetime),
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
                child: ForecastIconWidget(
                  icon: widget.dayForecast.icon,
                  width: 50,
                ),
              ),
            ],
          ),
          if (widget.dayForecast.hourlyForecast != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: colorScheme.surface,
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 100),
                    turns: _expanded ? .5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
