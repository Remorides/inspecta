import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:omdk/pages/app/app.dart';
import 'package:omdk/pages/app/app_bloc_observer.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_mapping/omdk_mapping.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:opera_api_auth/opera_api_auth.dart';
import 'package:opera_repo/opera_repo.dart';

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

  final operaRepo = OperaRepo(omdkLocalData);

  final assetRepo = EntityRepo(
    OperaApiAsset(omdkApi.apiClient.client),
    entityIsarSchema: (!kIsWeb) ? AssetSchema : null,
  );

  final schemaListRepo = EntityRepo(
    OperaApiSchemaListItem(omdkApi.apiClient.client),
  );

  final schemaRepo = EntityRepo(
    OperaApiSchema(omdkApi.apiClient.client),
    entityIsarSchema: (!kIsWeb) ? OSchemaSchema : null,
  );

  final mappingRepo = EntityRepo(
    OmdkMapping(omdkApi.apiClient.client),
    entityIsarSchema: (!kIsWeb) ? MappingVersionSchema : null,
  );

  final scheduledRepo = EntityRepo(
    OperaApiScheduled(omdkApi.apiClient.client),
    entityIsarSchema: (!kIsWeb) ? ScheduledActivitySchema : null,
  );

  runApp(
    App(
      operaRepo: operaRepo,
      assetRepo: assetRepo,
      authRepo: authRepo,
      schemaRepo: schemaRepo,
      omdkLocalData: omdkLocalData,
      schemaListRepo: schemaListRepo,
      mappingRepo: mappingRepo,
      scheduledRepo: scheduledRepo,
    ),
  );
}
