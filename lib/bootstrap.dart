import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_inspecta/blocs/app/app.dart';
import 'package:omdk_inspecta/blocs/app/app_bloc_observer.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_auth/opera_api_auth.dart';

/// Bootstrap class load custom BlocObserver and create repoLayer instance
Future<void> bootstrap({
  required OMDKApi omdkApi,
  required OMDKLocalData omdkLocalData,
  required String? companyCode,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final IAuthApi<AuthSession> authApi = OperaApiAuth(omdkApi.apiClient.client);
  final authRepo = AuthRepo(
    authApi,
    localData: omdkLocalData,
    omdkApi: omdkApi,
  );

  if (!kIsWeb) {
    omdkLocalData.coordinateProvider.resumeStreamPosition();
  }
  final defaultTheme =
      await omdkLocalData.themeManager.getTheme(ThemeEnum.light);

  runApp(
    App(
      authRepo: authRepo,
      omdkApi: omdkApi,
      omdkLocalData: omdkLocalData,
      defaultTheme: defaultTheme,
      companyCode: companyCode,
    ),
  );
}
