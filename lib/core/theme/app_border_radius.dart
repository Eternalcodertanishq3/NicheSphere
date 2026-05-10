import 'package:flutter/material.dart';

/// NicheSphere Design System — Border Radius Scale
/// Section 1.6 of the master spec.
class AppBorderRadius {
  AppBorderRadius._();

  static const double xsValue = 8;
  static const double smValue = 12;
  static const double mdValue = 16;
  static const double lgValue = 24;
  static const double xlValue = 32;
  static const double xxlValue = 40;
  static const double pillValue = 999;

  static BorderRadius get xs => BorderRadius.circular(xsValue);
  static BorderRadius get sm => BorderRadius.circular(smValue);
  static BorderRadius get md => BorderRadius.circular(mdValue);
  static BorderRadius get lg => BorderRadius.circular(lgValue);
  static BorderRadius get xl => BorderRadius.circular(xlValue);
  static BorderRadius get xxl => BorderRadius.circular(xxlValue);
  static BorderRadius get pill => BorderRadius.circular(pillValue);
}
