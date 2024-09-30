import 'package:flutter/material.dart';

const _seedColor = Colors.deepPurple;

final lighTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor, brightness: Brightness.light));

final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor, brightness: Brightness.dark));
