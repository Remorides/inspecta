import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_inspecta/blocs/sync/configs/configs_state.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';

class ConfigsCubit extends HydratedCubit<ConfigsState> {
  ConfigsCubit({
    required OMDKApi omdkApi,
  })  : _omdkApi = omdkApi,
        super(const ConfigsState()) {
    _updateApiEndpoint(state.currentConfig?.apiEndpoint);
  }

  final OMDKApi _omdkApi;

  void _updateApiEndpoint(String? apiEndpoint) {
    _omdkApi.apiClient.client.options =
        _omdkApi.apiClient.client.options.copyWith(
      baseUrl: apiEndpoint,
    );
  }

  void saveConfig(String companyCode, CompanyConfiguration config) {
    return emit(
      ConfigsState(
        companies: List.from(state.companies)..add(companyCode),
        configs: List.from(state.configs)..add({companyCode: config}),
        currentCompany: state.currentCompany ?? companyCode,
        currentConfig: state.currentConfig ?? config,
      ),
    );
  }

  void deleteConfig(String companyCode) {
    final updatedCompanies = List<String>.from(state.companies)
      ..remove(companyCode);
    final updatedConfigs =
        List<Map<String, CompanyConfiguration>>.from(state.configs)
          ..removeWhere((i) => i.keys.first == companyCode);
    return emit(
      ConfigsState(
        companies: updatedCompanies,
        configs: updatedConfigs,
        currentCompany: companyCode == state.currentCompany
            ? updatedConfigs.first.keys.first
            : state.currentCompany,
        currentConfig: companyCode == state.currentCompany
            ? updatedConfigs.first.values.first
            : state.currentConfig,
      ),
    );
  }

  void selectConfig(String companyCode) {
    final companyConfig = state.configs
        .singleWhere((c) => c.keys.first == companyCode)
        .values
        .first;
    _updateApiEndpoint(companyConfig.apiEndpoint);
    return emit(
      ConfigsState(
        companies: state.companies,
        configs: state.configs,
        currentCompany: companyCode,
        currentConfig: companyConfig,
      ),
    );
  }

  @override
  ConfigsState fromJson(Map<String, dynamic> json) =>
      ConfigsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ConfigsState state) => state.toJson();
}
