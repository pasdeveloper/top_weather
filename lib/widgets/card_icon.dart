import 'package:flutter/material.dart';

Widget cardIconFrom(IconData icon, ColorScheme colorScheme) => Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: colorScheme.surface),
      width: 35,
      height: 35,
      child: Icon(
        icon,
        color: colorScheme.onSurface,
        size: 20,
      ),
    );
