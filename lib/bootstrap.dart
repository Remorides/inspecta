import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:omdk/pages/app/app.dart';
import 'package:omdk/pages/app/app_bloc_observer.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_auth/opera_api_auth.dart';

/// Bootstrap class load custom BlocObserver and create repoLayer instance
Future<void> bootstrap({
  required OMDKApi omdkApi,
  required OMDKLocalData omdkLocalData,
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

  runApp(
    App(
      authRepo: authRepo,
      omdkLocalData: omdkLocalData,
    ),
  );
}
