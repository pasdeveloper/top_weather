import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_weather/constants/assets.dart';
import 'package:top_weather/models/forecast.dart';

class ForecastIconWidget extends StatelessWidget {
  const ForecastIconWidget(
      {super.key,
      required this.icon,
      this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.colorFilter});

  final ForecastIcon icon;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return SvgPicture.asset(
      _getAsset(icon, isDark),
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
    );
  }
}

String _getAsset(ForecastIcon icon, bool isDark) {
  switch (icon) {
    case ForecastIcon.blizzard:
      return isDark
          ? Assets.weatherIconDarkBlizzard
          : Assets.weatherIconLightBlizzard;
    case ForecastIcon.blowingSnow:
      return isDark
          ? Assets.weatherIconDarkBlowingSnow
          : Assets.weatherIconLightBlowingSnow;
    case ForecastIcon.clearNight:
      return isDark
          ? Assets.weatherIconDarkClearNight
          : Assets.weatherIconLightClearNight;
    case ForecastIcon.clearDay:
      return isDark
          ? Assets.weatherIconDarkClearDay
          : Assets.weatherIconLightClearDay;
    case ForecastIcon.cloudy:
      return isDark
          ? Assets.weatherIconDarkCloudy
          : Assets.weatherIconLightCloudy;
    case ForecastIcon.cloudyWithRain:
      return isDark
          ? Assets.weatherIconDarkCloudyWithRain
          : Assets.weatherIconLightCloudyWithRain;
    case ForecastIcon.cloudyWithSnow:
      return isDark
          ? Assets.weatherIconDarkCloudyWithSnow
          : Assets.weatherIconLightCloudyWithSnow;
    case ForecastIcon.cloudyWithSunny:
      return isDark
          ? Assets.weatherIconDarkCloudyWithSunny
          : Assets.weatherIconLightCloudyWithSunny;
    case ForecastIcon.drizzle:
      return isDark
          ? Assets.weatherIconDarkDrizzle
          : Assets.weatherIconLightDrizzle;
    case ForecastIcon.flurries:
      return isDark
          ? Assets.weatherIconDarkFlurries
          : Assets.weatherIconLightFlurries;
    case ForecastIcon.hazeFogDustSmoke:
      return isDark
          ? Assets.weatherIconDarkHazeFogDustSmoke
          : Assets.weatherIconLightHazeFogDustSmoke;
    case ForecastIcon.heavyRain:
      return isDark
          ? Assets.weatherIconDarkHeavyRain
          : Assets.weatherIconLightHeavyRain;
    case ForecastIcon.heavySnow:
      return isDark
          ? Assets.weatherIconDarkHeavySnow
          : Assets.weatherIconLightHeavySnow;
    case ForecastIcon.icy:
      return isDark ? Assets.weatherIconDarkIcy : Assets.weatherIconLightIcy;
    case ForecastIcon.isolatedScatteredThunderstormsDay:
      return isDark
          ? Assets.weatherIconDarkIsolatedScatteredThunderstormsDay
          : Assets.weatherIconLightIsolatedScatteredThunderstormsDay;
    case ForecastIcon.isolatedScatteredThunderstormsNight:
      return isDark
          ? Assets.weatherIconDarkIsolatedScatteredThunderstormsNight
          : Assets.weatherIconLightIsolatedScatteredThunderstormsNight;
    case ForecastIcon.isolatedThunderstorms:
      return isDark
          ? Assets.weatherIconDarkIsolatedThunderstorms
          : Assets.weatherIconLightIsolatedThunderstorms;
    case ForecastIcon.mixedRainSnow:
      return isDark
          ? Assets.weatherIconDarkMixedRainSnow
          : Assets.weatherIconLightMixedRainSnow;
    case ForecastIcon.mixedRainSleetHail:
      return isDark
          ? Assets.weatherIconDarkMixedRainSleetHail
          : Assets.weatherIconLightMixedRainHailSleet;
    case ForecastIcon.mostlyClearDay:
      return isDark
          ? Assets.weatherIconDarkMostlyClearDay
          : Assets.weatherIconLightMostlyClearDay;
    case ForecastIcon.mostlyClearNight:
      return isDark
          ? Assets.weatherIconDarkMostlyClearNight
          : Assets.weatherIconLightMostlyClearNight;
    case ForecastIcon.mostlyCloudyDay:
      return isDark
          ? Assets.weatherIconDarkMostlyCloudyDay
          : Assets.weatherIconLightMostlyCloudyDay;
    case ForecastIcon.mostlyCloudyNight:
      return isDark
          ? Assets.weatherIconDarkMostlyCloudyNight
          : Assets.weatherIconLightMostlyCloudyNight;
    case ForecastIcon.notAvailable:
      return isDark
          ? Assets.weatherIconDarkNotAvailable
          : Assets.weatherIconLightNotAvailable;
    case ForecastIcon.partlyCloudyDay:
      return isDark
          ? Assets.weatherIconDarkPartlyCloudy
          : Assets.weatherIconLightPartlyCloudyDay;
    case ForecastIcon.partlyCloudyNight:
      return isDark
          ? Assets.weatherIconDarkPartlyCloudyNight
          : Assets.weatherIconLightPartlyCloudyNight;
    case ForecastIcon.scatteredShowersDay:
      return isDark
          ? Assets.weatherIconDarkScatteredShowersDay
          : Assets.weatherIconLightScatteredShowersDay;
    case ForecastIcon.scatteredShowersNight:
      return isDark
          ? Assets.weatherIconDarkScatteredShowersNight
          : Assets.weatherIconLightScatteredShowersNight;
    case ForecastIcon.scatteredSnowShowersDay:
      return isDark
          ? Assets.weatherIconDarkScatteredSnowShowersDay
          : Assets.weatherIconLightScatteredSnowShowersDay;
    case ForecastIcon.scatteredSnowShowersNight:
      return isDark
          ? Assets.weatherIconDarkScatteredSnowShowersNight
          : Assets.weatherIconLightScatteredSnowShowersNight;
    case ForecastIcon.showersRain:
      return isDark
          ? Assets.weatherIconDarkShowersRain
          : Assets.weatherIconLightShowersRain;
    case ForecastIcon.showersSnow:
      return isDark
          ? Assets.weatherIconDarkShowersSnow
          : Assets.weatherIconLightShowersSnow;
    case ForecastIcon.sleetHail:
      return isDark
          ? Assets.weatherIconDarkSleetHail
          : Assets.weatherIconLightSleetHail;
    case ForecastIcon.strongThunderstorms:
      return isDark
          ? Assets.weatherIconDarkStrongThunderstorms
          : Assets.weatherIconLightStrongThunderstorms;
    case ForecastIcon.sunnyAndCloudy:
      return isDark
          ? Assets.weatherIconDarkSunnyAndCloudy
          : Assets.weatherIconLightSunnyAndCloudy;
    case ForecastIcon.sunnyWithRainDarkSky:
      return isDark
          ? Assets.weatherIconDarkSunnyWithRainDark
          : Assets.weatherIconLightSunnyWithRain;
    case ForecastIcon.sunnyWithSnow:
      return isDark
          ? Assets.weatherIconDarkSunnyWithSnow
          : Assets.weatherIconLightSunnyWithSnow;
    case ForecastIcon.tornado:
      return isDark
          ? Assets.weatherIconDarkTornado
          : Assets.weatherIconLightTornado;
    case ForecastIcon.tropicalStormHurricane:
      return isDark
          ? Assets.weatherIconDarkTropicalStormHurricane
          : Assets.weatherIconLightTropicalStormHurricane;
    case ForecastIcon.veryCold:
      return isDark
          ? Assets.weatherIconDarkVeryCold
          : Assets.weatherIconLightVeryCold;
    case ForecastIcon.veryHot:
      return isDark
          ? Assets.weatherIconDarkVeryHot
          : Assets.weatherIconLightVeryHot;
    case ForecastIcon.windyBreezy:
      return isDark
          ? Assets.weatherIconDarkWindyBreezy
          : Assets.weatherIconLightWindyBreezy;
  }
}
