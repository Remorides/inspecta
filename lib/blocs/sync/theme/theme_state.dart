part of 'theme_cubit.dart';

class ThemeState {
  const ThemeState({
    this.companyCode,
    this.themeData,
    this.themeEnum = ThemeEnum.light,
  });

  /// JsonMap to Object
  factory ThemeState.fromJson(JsonMap json) => _$ThemeStateFromJson(json);

  final String? companyCode;
  final ThemeData? themeData;
  final ThemeEnum themeEnum;

  /// Object to JsonMap
  JsonMap toJson() => _$ThemeStateToJson(this);
}

ThemeState _$ThemeStateFromJson(Map<String, dynamic> json) => ThemeState(
      companyCode: json['companyCode'] as String?,
      themeEnum: $enumDecodeNullable(_$ActViewTypeEnumMap, json['themeEnum']) ??
          ThemeEnum.light,
      themeData: json['themeData'] != null
          ? ThemeDecoder.decodeThemeData(json['themeData'])
          : null,
    );

Map<String, dynamic> _$ThemeStateToJson(ThemeState instance) =>
    <String, dynamic>{
      'companyCode': instance.companyCode,
      'themeEnum': _$ActViewTypeEnumMap[instance.themeEnum],
      'themeData': instance.themeData != null
          ? ThemeEncoder.encodeThemeData(instance.themeData)
          : null,
    };

const _$ActViewTypeEnumMap = {
  ThemeEnum.light: 'grid',
  ThemeEnum.dark: 'timeline',
  ThemeEnum.customLight: 'customLight',
  ThemeEnum.customDark: 'customDark',
};
