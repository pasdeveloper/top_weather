import 'package:flutter/material.dart';
import 'package:top_weather/core/locator.dart';
import 'package:top_weather/screens/homepage.dart';

final _theme =
    ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue));
void main() {
  locatorSetup();
  runApp(MaterialApp(
    home: const Homepage(),
    theme: _theme,
  ));
}
