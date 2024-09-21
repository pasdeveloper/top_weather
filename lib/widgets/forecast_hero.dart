import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_weather/core/app_images.dart';
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
      height: 250,
      padding: const EdgeInsets.all(30),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: SvgPicture.asset(
              AppImages.iconPathByName(conditions.icon),
              height: 150,
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
