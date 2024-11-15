import 'package:json_annotation/json_annotation.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';

part 'configs_state.g.dart';

@JsonSerializable()
class ConfigsState {
  const ConfigsState({
    this.companies = const [],
    this.configs = const [],
    this.currentCompany,
    this.currentConfig,
  });

  /// JsonMap to Object
  factory ConfigsState.fromJson(JsonMap json) => _$ConfigsStateFromJson(json);

  final List<String> companies;
  final List<Map<String, CompanyConfiguration>> configs;
  final String? currentCompany;
  final CompanyConfiguration? currentConfig;

  /// Object to JsonMap
  JsonMap toJson() => _$ConfigsStateToJson(this);
}
