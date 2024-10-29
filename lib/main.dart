import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_inspecta/bootstrap.dart';
import 'package:omdk_local_data/omdk_local_data.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'assets/.env');
  WidgetsFlutterBinding.ensureInitialized();

  final omdkApi = OMDKApi(baseUrl: dotenv.env['API_ENDPOINT']!);
  final omdkLocalData = OMDKLocalData();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await omdkLocalData.fileManager.getApplicationDocumentsDir,
  );

  /// Setting SystemUIMode
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  /// Set image cache
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;

  await bootstrap(
    omdkApi: omdkApi,
    omdkLocalData: omdkLocalData,
    companyCode: dotenv.env['COMPANY_CODE'],
  );
}
