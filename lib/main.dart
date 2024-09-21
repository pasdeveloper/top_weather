import 'package:flutter/material.dart';
import 'package:top_weather/configurations/locator.dart';
import 'package:top_weather/screens/homepage.dart';

void main() {
  locatorSetup();
  runApp(const MaterialApp(home: Homepage()));
}
