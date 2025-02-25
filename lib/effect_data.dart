import 'package:flutter/material.dart';

class EffectData {
  final String id;
  final String label;
  final IconData iconData;
  double sliderValue;
  final double sliderMax;
  final double sliderMin;
  final int sliderdiv;
  EffectData({
    required this.iconData,
    required this.label,
    required this.id,
    required this.sliderMax,
    required this.sliderMin,
    required this.sliderValue,
    required this.sliderdiv,
  });
  @override
  String toString() {
    return "$id-$sliderMax-$sliderMin-$sliderValue-$sliderdiv";
  }

  String get currentValue => sliderValue.toStringAsFixed(1);
}

class EffectHistory {
  final String id;
  final String label;
  final double startValue;
  double endValue;
  EffectHistory({
    required this.endValue,
    required this.id,
    required this.label,
    required this.startValue,
  });
}
