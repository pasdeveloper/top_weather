import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _seedColor = Colors.deepPurple;
final _textTheme = GoogleFonts.poppinsTextTheme();

final lighTheme = ThemeData.from(
  colorScheme:
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light),
  textTheme: _textTheme,
);

final darkTheme = ThemeData.from(
  colorScheme:
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
  textTheme: _textTheme,
);
