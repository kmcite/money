// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      materialColor: json['materialColor'] == null
          ? Colors.deepPurple
          : const MaterialColorConverter()
              .fromJson((json['materialColor'] as num).toInt()),
      pageIndex: (json['pageIndex'] as num?)?.toInt() ?? 0,
      borderRadiusEnum: $enumDecodeNullable(
              _$BorderRadiusEnumEnumMap, json['borderRadiusEnum']) ??
          BorderRadiusEnum.full,
      paddingEnum:
          $enumDecodeNullable(_$PaddingEnumEnumMap, json['paddingEnum']) ??
              PaddingEnum.relaxed,
      backgroundImagePath: json['backgroundImagePath'] as String? ?? '',
      useMaterial3: json['useMaterial3'] as bool? ?? true,
      font: json['font'] as String? ?? 'Default',
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'materialColor':
          const MaterialColorConverter().toJson(instance.materialColor),
      'pageIndex': instance.pageIndex,
      'borderRadiusEnum': _$BorderRadiusEnumEnumMap[instance.borderRadiusEnum]!,
      'paddingEnum': _$PaddingEnumEnumMap[instance.paddingEnum]!,
      'backgroundImagePath': instance.backgroundImagePath,
      'useMaterial3': instance.useMaterial3,
      'font': instance.font,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$BorderRadiusEnumEnumMap = {
  BorderRadiusEnum.none: 'none',
  BorderRadiusEnum.minimal: 'minimal',
  BorderRadiusEnum.normal: 'normal',
  BorderRadiusEnum.extra: 'extra',
  BorderRadiusEnum.full: 'full',
};

const _$PaddingEnumEnumMap = {
  PaddingEnum.none: 'none',
  PaddingEnum.tight: 'tight',
  PaddingEnum.normal: 'normal',
  PaddingEnum.relaxed: 'relaxed',
};
