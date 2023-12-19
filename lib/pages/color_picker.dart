import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gucy/main.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key, required this.themeMode});
  final ValueChanged<ThemeMode> themeMode;

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  late Color screenPickerColor; // Color for picker shown in Card on the screen.
  late Color dialogPickerColor; // Color for picker in dialog using onChanged
  late Color dialogSelectColor; // Color for picker using color select dialog.
  late bool isDark;

  // Define some custom colors for the custom picker segment.
  // The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  @override
  void initState() {
    screenPickerColor = Colors.blue;
    dialogPickerColor = Colors.red;
    dialogSelectColor = const Color(0xFFA239CA);
    isDark = false;

    setState(() {
      isDark = Provider.of<UserProvider>(context, listen: false).brightness ==
          Brightness.dark;
      dialogPickerColor =
          Provider.of<UserProvider>(context, listen: false).chosenColor;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ColorPicker Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        children: <Widget>[
          const SizedBox(height: 16),
          // Pick color in a dialog.
          ListTile(
            title: const Text('Click this color to modify it in a dialog. '
                'The color is modified while dialog is open, but returns '
                'to previous value if dialog is cancelled. Note that you need to restart the app for the changes to take effect.'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(dialogPickerColor, colorSwatchNameMap: colorsNameMap)} '
              'aka ${ColorTools.nameThatColor(dialogPickerColor)}',
            ),
            trailing: ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: 4,
              color: dialogPickerColor,
              onSelectFocus: false,
              onSelect: () async {
                // Store current color before we open the dialog.
                final Color colorBeforeDialog = dialogPickerColor;
                // Wait for the picker to close, if dialog was dismissed,
                // then restore the color we had before it was opened.
                if (!(await colorPickerDialog())) {
                  setState(() {
                    dialogPickerColor = colorBeforeDialog;
                  });
                  Provider.of<UserProvider>(context, listen: true)
                      .saveUserPreferences(
                          isDarkMode: isDark, chosenColor: dialogPickerColor);
                }
              },
            ),
          ),

          // Theme mode toggle
          SwitchListTile(
            title: const Text('Turn ON for dark mode'),
            subtitle: const Text(
                'Turn OFF for light mode. Note that you need to restart the app for the changes to take effect. '),
            value: isDark,
            onChanged: (bool value) {
              setState(() {
                isDark = value;
                widget.themeMode(isDark ? ThemeMode.dark : ThemeMode.light);
              });
              Provider.of<UserProvider>(context, listen: false)
                  .saveUserPreferences(
                      isDarkMode: isDark, chosenColor: dialogPickerColor);
              RestartWidget.restartApp(context);
            },
          )
        ],
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChangeEnd: (Color color) {
        Provider.of<UserProvider>(context, listen: false).saveUserPreferences(
            isDarkMode: isDark, chosenColor: dialogPickerColor);
      },
      onColorChanged: (Color color) => setState(() {
        dialogPickerColor = color;
      }),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }
}
