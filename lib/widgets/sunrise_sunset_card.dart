import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_weather/core/app_images.dart';
import 'package:top_weather/core/date_utils.dart';
import 'package:top_weather/models/weather_data.dart';

class SunriseSunsetCard extends StatelessWidget {
  const SunriseSunsetCard(this.conditions, {super.key});

  final Conditions conditions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    AppImages.sunrise,
                    height: 120,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      conditions.sunriseEpoch == null
                          ? 'Unknown'
                          : toTime(conditions.sunriseEpoch!),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Stack(
                children: [
                  SvgPicture.asset(
                    AppImages.sunset,
                    height: 120,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      conditions.sunsetEpoch == null
                          ? 'Unknown'
                          : toTime(conditions.sunsetEpoch!),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
