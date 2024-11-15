// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configs_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigsState _$ConfigsStateFromJson(Map<String, dynamic> json) => ConfigsState(
      companies: (json['companies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      configs: (json['configs'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        k,
                        CompanyConfiguration.fromJson(
                            e as Map<String, dynamic>)),
                  ))
              .toList() ??
          const [],
      currentCompany: json['currentCompany'] as String?,
      currentConfig: json['currentConfig'] == null
          ? null
          : CompanyConfiguration.fromJson(
              json['currentConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfigsStateToJson(ConfigsState instance) =>
    <String, dynamic>{
      'companies': instance.companies,
      'configs': instance.configs,
      'currentCompany': instance.currentCompany,
      'currentConfig': instance.currentConfig,
    };
