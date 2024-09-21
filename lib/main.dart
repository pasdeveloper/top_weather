import 'package:flutter/material.dart';
import 'package:top_weather/core/locator.dart';
import 'package:top_weather/screens/homepage.dart';

void main() {
  locatorSetup();
  runApp(const MaterialApp(home: Homepage()));
}
