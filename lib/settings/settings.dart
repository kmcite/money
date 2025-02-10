import '../main.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

final settingsRM = RM.inject(
  () => Settings(),
  // persist: () => persisted(
  //   'settings',
  //   Settings.fromJson,
  // ),
);
Settings settings([Settings? settings]) {
  if (settings != null) settingsRM.state = settings;
  return settingsRM.state;
}

ThemeMode themeMode([ThemeMode? _]) {
  if (_ != null) settings(settings().copyWith(themeMode: _));
  return settings().themeMode;
}

MaterialColor materialColor([MaterialColor? _]) {
  if (_ != null) settings(settings().copyWith(materialColor: _));
  return settings().materialColor;
}

String font([String? _]) {
  if (_ != null) settings(settings().copyWith(font: _));
  return settings().font;
}

bool useMaterial3([bool? _]) {
  if (_ != null) settings(settings().copyWith(useMaterial3: _));
  return settings().useMaterial3;
}

double borderRadius([BorderRadiusEnum? _]) {
  if (_ != null) settings(settings().copyWith(borderRadiusEnum: _));
  return settings().borderRadius;
}

double padding([PaddingEnum? _]) {
  if (_ != null) settings(settings().copyWith(paddingEnum: _));
  return settings().padding;
}

String backgroundImagePath([String? _]) {
  if (_ != null) settings(settings().copyWith(backgroundImagePath: _));
  return settings().backgroundImagePath;
}

@freezed
class Settings with _$Settings {
  const factory Settings({
    @Default(ThemeMode.system) final ThemeMode themeMode,
    @MaterialColorConverter()
    @Default(Colors.deepPurple)
    final MaterialColor materialColor,
    @Default(0) final int pageIndex,
    @Default(BorderRadiusEnum.full) final BorderRadiusEnum borderRadiusEnum,
    @Default(PaddingEnum.relaxed) final PaddingEnum paddingEnum,
    @Default('') final String backgroundImagePath,
    @Default(true) final bool useMaterial3,
    @Default('Default') final String font,
  }) = _Settings;

  factory Settings.fromJson(json) => _$SettingsFromJson(json);

  Uint8List? get backgroundImage {
    try {
      File file = File(this.backgroundImagePath);
      return file.readAsBytesSync();
    } catch (e) {
      return null;
    }
  }

  double get borderRadius {
    return switch (borderRadiusEnum) {
      BorderRadiusEnum.none => 2,
      BorderRadiusEnum.minimal => 5,
      BorderRadiusEnum.normal => 10,
      BorderRadiusEnum.extra => 17,
      BorderRadiusEnum.full => 30,
    };
  }

  double get padding => switch (paddingEnum) {
        PaddingEnum.none => 4,
        PaddingEnum.tight => 7,
        PaddingEnum.normal => 10,
        PaddingEnum.relaxed => 13,
      };
  const Settings._();
}

enum BorderRadiusEnum {
  none,
  minimal,
  normal,
  extra,
  full;
}

enum PaddingEnum {
  none,
  tight,
  normal,
  relaxed;
}
