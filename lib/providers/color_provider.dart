import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorProvider extends ChangeNotifier {
  late Brightness brightness = Brightness.light;
  late Color chosenColor = Colors.orange;

  ColorProvider() {
    loadUserPrefs();
  }
  Future<void> loadUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    brightness = isDarkMode ? Brightness.dark : Brightness.light;
    int colorValue =
        prefs.getInt('chosenColor') ?? Color.fromARGB(255, 17, 186, 76).value;
    chosenColor = Color(colorValue);

    notifyListeners();
  }

  Future<void> saveUserPreferences({
    required bool isDarkMode,
    required Color chosenColor,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setInt('chosenColor', chosenColor.value);

    brightness = isDarkMode ? Brightness.dark : Brightness.light;
    this.chosenColor = chosenColor;

    notifyListeners();
  }
}
