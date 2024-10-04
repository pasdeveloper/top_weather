import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:top_weather/core/locale_date_formatting.dart';
import 'package:top_weather/l10n/localizations_export.dart';
import 'package:top_weather/models/forecast.dart';

class DailyTemperatureGraph extends StatelessWidget {
  const DailyTemperatureGraph({
    required this.dailyForecast,
    super.key,
  });

  final DailyForecast dailyForecast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final startingDate = dailyForecast.days[0].datetime;
    final maxTemperature = dailyForecast.days
        .map((dayForecast) => dayForecast.maxTemperature)
        .reduce((t1, t2) => t1 > t2 ? t1 : t2);
    final minTemperature = dailyForecast.days
        .map((dayForecast) => dayForecast.minTemperature)
        .reduce((t1, t2) => t1 < t2 ? t1 : t2);

    final dateFormatting =
        LocaleDateFormatting(AppLocalizations.of(context)!.localeName);

    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(
        maxY: maxTemperature + 3,
        minY: minTemperature - 3,
        // minX: -0.5,
        // maxX: dailyForecast.days.length - 0.5,
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(strokeWidth: 1, color: colorScheme.onPrimaryContainer),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _getLineChartBarData(
              Colors.red,
              (previousValue, element) => [
                    ...previousValue,
                    FlSpot(
                        previousValue.length.toDouble(), element.maxTemperature)
                  ],
              dailyForecast),
          _getLineChartBarData(
              Colors.blue,
              (previousValue, element) => [
                    ...previousValue,
                    FlSpot(
                        previousValue.length.toDouble(), element.minTemperature)
                  ],
              dailyForecast),
        ],
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            maxIncluded: false,
            minIncluded: false,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: meta.axisSide,
              fitInside: SideTitleFitInsideData.fromTitleMeta(meta,
                  distanceFromEdge: 0),
              child: Text(
                '${value.toInt()}°',
                style: textTheme.labelMedium!
                    .copyWith(color: colorScheme.onPrimaryContainer),
              ),
            ),
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              // maxIncluded: false,
              // minIncluded: false,
              getTitlesWidget: (value, meta) {
                final nextDate =
                    startingDate.add(Duration(days: value.toInt()));

                return SideTitleWidget(
                  space: 4,
                  axisSide: meta.axisSide,
                  fitInside: SideTitleFitInsideData.fromTitleMeta(meta,
                      distanceFromEdge: 0),
                  child: Text(
                    dateFormatting.shortDayNameFormatter.format(nextDate),
                    style: textTheme.labelMedium!
                        .copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (touchedSpot) => colorScheme.surface,
            getTooltipItems: (touchedSpots) => touchedSpots
                .map(
                  (touchedSpot) => LineTooltipItem(
                    '${touchedSpot.y.toInt()}°',
                    textTheme.bodyLarge!.copyWith(color: touchedSpot.bar.color),
                  ),
                )
                .toList(),
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes
              .map(
                (spotIndex) => TouchedSpotIndicatorData(
                  FlLine(strokeWidth: 2, color: barData.color, dashArray: [8]),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(color: barData.color!),
                  ),
                ),
              )
              .toList(),
        ),
      )),
    );
  }
}

LineChartBarData _getLineChartBarData(
    Color color,
    List<FlSpot> Function(List<FlSpot>, DayForecast) foldFunction,
    DailyForecast dailyForecast) {
  return LineChartBarData(
    color: color,
    isCurved: true,
    isStrokeCapRound: true,
    preventCurveOverShooting: true,
    dotData: const FlDotData(show: false),
    spots: dailyForecast.days.fold<List<FlSpot>>(
      [],
      foldFunction,
    ),
    barWidth: 3,
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          // color.withOpacity(1),
          color.withOpacity(.2),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}
