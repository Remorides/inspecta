import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_theme/json_theme.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit({
    String? companyCode,
    required OMDKLocalData localData,
    required OperaThemeRepo themeRepo,
    required ThemeData defaultTheme,
  })  : _localData = localData,
        _themeRepo = themeRepo,
        super(ThemeState(themeData: defaultTheme)) {
    updateCustomThemes(companyCode);
  }

  final OMDKLocalData _localData;
  final OperaThemeRepo _themeRepo;

  Future<void> switchTheme(String? companyCode) async {
    switch (state.themeEnum) {
      case ThemeEnum.dark:
        await changeTheme(ThemeEnum.light, companyCode);
      case ThemeEnum.light:
        await changeTheme(ThemeEnum.dark, companyCode);
      case ThemeEnum.customDark:
        await changeTheme(ThemeEnum.customLight, companyCode);
      case ThemeEnum.customLight:
        await changeTheme(ThemeEnum.customDark, companyCode);
    }
  }

  Future<void> changeTheme(
    ThemeEnum themeEnum,
    String? companyCode,
  ) async {
    try {
      final newThemeData = await _localData.themeManager.getTheme(
        themeEnum,
        companyCode ?? state.companyCode ?? '',
      );
      return emit(
        ThemeState(
          themeData: newThemeData,
          themeEnum: themeEnum,
          companyCode: state.companyCode ?? companyCode,
        ),
      );
    } catch (e, s) {
      _localData.logManager.log(
        LogType.warning,
        e.toString(),
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> updateCustomThemes([String? companyCode]) async {
    try {
      //Light theme
      await _themeRepo.downloadAndSaveCustomTheme(
        companyCode ?? state.companyCode!,
        clientType: ClientType.Webapp,
      );
      //Dark theme
      await _themeRepo.downloadAndSaveCustomTheme(
        clientType: ClientType.Webapp,
        companyCode ?? state.companyCode!,
        themeEnum: ThemeEnum.customDark,
      );
      await changeTheme(
        companyCode != null ? ThemeEnum.customLight : state.themeEnum,
        companyCode ?? state.companyCode,
      );
    } on Exception catch (e, s) {
      _localData.logManager.log(
        LogType.error,
        e.toString(),
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) => ThemeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ThemeState state) => state.toJson();
}
