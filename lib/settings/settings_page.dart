import '../main.dart';

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Settings'.text(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Material 3 Support',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: materialColor()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            child: SwitchListTile(
              title: 'Material 3'.text(),
              subtitle: 'Enable Material 3 Support'.text(),
              value: useMaterial3(),
              onChanged: useMaterial3,
              secondary: Icon(Icons.style, color: materialColor()),
            ),
          ).pad(),
          DropdownButtonFormField(
            value: themeMode(),
            items: ThemeMode.values.map(
              (eachThemeMode) {
                return DropdownMenuItem(
                  value: eachThemeMode,
                  child: Row(
                    children: [
                      Icon(
                          eachThemeMode == ThemeMode.dark
                              ? Icons.dark_mode
                              : eachThemeMode == ThemeMode.light
                                  ? Icons.light_mode
                                  : Icons.brightness_auto,
                          color: materialColor()),
                      SizedBox(width: 12),
                      eachThemeMode.name.toUpperCase().text(),
                    ],
                  ),
                );
              },
            ).toList(),
            onChanged: themeMode,
            decoration: InputDecoration(
              labelText: 'Theme Mode',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: materialColor()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ).pad(),
          DropdownButtonFormField(
            value: materialColor(),
            items: Colors.primaries
                .map(
                  (eachMaterialColor) => DropdownMenuItem(
                    value: eachMaterialColor,
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: eachMaterialColor),
                        SizedBox(width: 12),
                        eachMaterialColor.colorName.toUpperCase().text(),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: materialColor,
            decoration: InputDecoration(
              labelText: 'Material Color',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: materialColor()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ).pad(),
          DropdownButtonFormField(
            value: font(),
            items: fonts.map(
              (eachFont) {
                return DropdownMenuItem(
                  value: eachFont,
                  child: Row(
                    children: [
                      Icon(Icons.text_fields, color: materialColor()),
                      SizedBox(width: 12),
                      eachFont.toString().toUpperCase().text(
                            style: TextStyle(
                              fontFamily: fontFamily(eachFont),
                              color: materialColor(),
                            ),
                          ),
                    ],
                  ),
                );
              },
            ).toList(),
            onChanged: font,
            decoration: InputDecoration(
              labelText: 'Font',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: materialColor()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ).pad(),
          DropdownButtonFormField(
            value: settings().paddingEnum,
            items: PaddingEnum.values
                .map(
                  (eachPaddingEnum) => DropdownMenuItem(
                    value: eachPaddingEnum,
                    child: Row(
                      children: [
                        Icon(Icons.space_bar, color: materialColor()),
                        SizedBox(width: 12),
                        eachPaddingEnum.name.toUpperCase().text(),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: padding,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Padding',
              labelStyle: TextStyle(color: materialColor()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ).pad(),
          DropdownButtonFormField(
            value: settings().borderRadiusEnum,
            items: BorderRadiusEnum.values
                .map(
                  (eachBorderRadiusEnum) => DropdownMenuItem(
                    value: eachBorderRadiusEnum,
                    child: Row(
                      children: [
                        Icon(Icons.rounded_corner, color: materialColor()),
                        SizedBox(width: 12),
                        eachBorderRadiusEnum.name.toUpperCase().text(),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: borderRadius,
            decoration: InputDecoration(
              labelText: 'Border Radius',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: materialColor()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ).pad(),
        ],
      ),
    );
  }
}
