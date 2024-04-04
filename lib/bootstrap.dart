import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:omdk/app/app.dart';
import 'package:omdk/app/app_bloc_observer.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

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
  final assetRepo = EntityRepo(
    iEntityApi: OperaApiAsset(omdkApi.client),
    entityIsarSchema: AssetSchema,
  );
  final assetListRepo = EntityRepo(
    iEntityApi: OperaApiAssetListItem(omdkApi.client),
  );

  runZonedGuarded(
    () => runApp(
      App(
        authRepo: authRepo,
        omdkLocalData: omdkLocalData,
        assetRepo: assetRepo,
        assetListRepo: assetListRepo,
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
