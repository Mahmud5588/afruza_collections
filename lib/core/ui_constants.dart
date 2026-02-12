import "package:flutter/material.dart";

class AppGradients {
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7F3EE), Color(0xFFE8DED2)],
  );

  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0E8DD)],
  );
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;
  static const double xl = 36;
}
