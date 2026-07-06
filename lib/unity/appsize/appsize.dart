import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Centralized responsive size helper.
/// Usage: final s = AppSizes(context);
/// Then use s.cardHeight, s.imageHeight, etc.
class AppSizes {
  final double screenWidth;
  final double screenHeight;
  final double effectiveWidth;

  AppSizes(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height,
        effectiveWidth = math.min(MediaQuery.of(context).size.width, 500);

  // ─── Spacing ───────────────────────────────────────────────
  double get spaceXS => screenHeight * 0.008;
  double get spaceS  => screenHeight * 0.012;
  double get spaceM  => screenHeight * 0.020;
  double get spaceL  => screenHeight * 0.030;
  double get spaceXL => screenHeight * 0.050;

  // ─── Font sizes ────────────────────────────────────────────
  double get fontXS  => effectiveWidth * 0.028; // ~10–11px
  double get fontS   => effectiveWidth * 0.032; // ~12px
  double get fontM   => effectiveWidth * 0.038; // ~14px
  double get fontL   => effectiveWidth * 0.044; // ~16px
  double get fontXL  => effectiveWidth * 0.055; // ~20px
  double get fontXXL => effectiveWidth * 0.065; // ~24px
  //
  // // ─── Component heights ──────────────────────────────────────
  // /// AddVehicleCard total height
  // double get addVehicleCardHeight => (screenHeight * 0.26).clamp(180.0, 240.0);
  //
  // /// AddVehicleCard car image height
  // double get addVehicleCardImageHeight => (screenHeight * 0.20).clamp(120.0, 180.0);
  //
  // /// Vehicle image in VehicleCard list
  // double get vehicleCardImageHeight => (screenHeight * 0.18).clamp(120.0, 200.0);
  //
  // /// Vehicle image in VehicleDetails screen
  // double get vehicleDetailImageHeight => (screenHeight * 0.24).clamp(160.0, 260.0);
  //
  // /// Home screen appBar height
  // double get homeAppBarHeight => (screenHeight * 0.30).clamp(245.0, 320.0);

  // ─── Padding / margin ──────────────────────────────────────
  double get pagePadding => effectiveWidth * 0.05;

  // ─── Border radius ─────────────────────────────────────────
  double get radiusM => 12.0;
  double get radiusL => 20.0;
  double get radiusXL => 24.0;
}