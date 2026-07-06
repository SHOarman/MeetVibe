import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle poppins({
    required double size,
    required FontWeight weight,
    Color? color,
    LinearGradient? gradient,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: gradient != null ? null : (color ?? Colors.black),
      foreground: gradient != null
          ? (Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0.0, 0.0, size * 10, size * 2),
        ))
          : null,
    );
  }

  static TextStyle outfit({
    required double size,
    required FontWeight weight,
    Color? color,
    LinearGradient? gradient,
  }) {
    return GoogleFonts.outfit(
      fontSize: size,
      fontWeight: weight,
      color: gradient != null ? null : (color ?? Colors.black),
      foreground: gradient != null
          ? (Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0.0, 0.0, size * 10, size * 2),
        ))
          : null,
    );
  }

  static TextStyle inter({
    required double size,
    required FontWeight weight,
    Color? color,
    LinearGradient? gradient,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: gradient != null ? null : (color ?? Colors.black),
      foreground: gradient != null
          ? (Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0.0, 0.0, size * 10, size * 2),
        ))
          : null,
    );
  }
}