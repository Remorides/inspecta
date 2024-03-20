import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:omdk/app/app.dart';
import 'package:omdk/app/app_bloc_observer.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Bootstrap class load custom BlocObserver and create repoLayer instance
void bootstrap({
  required OMDKApi omdkApi,
  required OMDKLocalData omdkLocalData,
}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final authRepo = AuthRepo(api: omdkApi, localData: omdkLocalData);

  runZonedGuarded(
    () => runApp(App(authRepo: authRepo, omdkLocalData: omdkLocalData,)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
