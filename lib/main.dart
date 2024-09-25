import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_weather/api/visual-crossing-weather/visual_crossing_weather_repository.dart';
import 'package:top_weather/blocs/bloc/weather_forecast_bloc.dart';
import 'package:top_weather/screens/homepage.dart';

final _theme =
    ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue));
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (context) => WeatherForecastBloc(
          weatherService: VisualCrossingWeatherRepository()),
      child: const Homepage(),
    ),
    theme: _theme,
  ));
}
