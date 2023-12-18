import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorSettings {
  static const String key = 'selected_color';

  static Future<Color> getSelectedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt(key);
    return Color(colorValue ?? Colors.blue.value); // Default to blue if not set
  }

  static Future<void> setSelectedColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, color.value);
  }
}
