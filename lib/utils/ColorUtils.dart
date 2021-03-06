
import 'package:flutter/material.dart';

class ColorUtils {

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if(hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    if(hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    }
  }

}