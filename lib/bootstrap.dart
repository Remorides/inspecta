import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_inspecta/blocs/app/app.dart';
import 'package:omdk_inspecta/blocs/app/app_bloc_observer.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:omdk_theme/omdk_theme.dart';
import 'package:opera_api_auth/opera_api_auth.dart';

/// Bootstrap class load custom BlocObserver and create repoLayer instance
Future<void> bootstrap({
  required OMDKApi omdkApi,
  required OMDKLocalData omdkLocalData,
  required String companyCode,
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

  final operaUtils = OperaUtils(omdkLocalData);

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
    OperaApiMapping(omdkApi.apiClient.client),
    entityIsarSchema: (!kIsWeb) ? MappingVersionSchema : null,
  );

  final scheduledRepo = EntityRepo(
    OperaApiScheduled(omdkApi.apiClient.client),
    entityIsarSchema: (!kIsWeb) ? ScheduledActivitySchema : null,
  );

  final themeRepo = ThemeRepo(
    omdkLocalData,
    themeRepo: OmdkApiTheme(omdkApi.apiClient.client),
  );

  final attachmentRepo = OperaAttachmentRepo(
    OperaApiAttachment(omdkApi.apiClient.client),
    entityIsarSchema: !kIsWeb ? AttachmentSchema : null,
  );

  await themeRepo.initTheme();

  runApp(
    App(
      operaUtils: operaUtils,
      assetRepo: assetRepo,
      authRepo: authRepo,
      schemaRepo: schemaRepo,
      omdkLocalData: omdkLocalData,
      schemaListRepo: schemaListRepo,
      mappingRepo: mappingRepo,
      scheduledRepo: scheduledRepo,
      companyCode: companyCode,
      themeRepo: themeRepo,
      attachmentRepo: attachmentRepo,
    ),
  );
}
