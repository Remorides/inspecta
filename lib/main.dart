import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:omdk/bootstrap.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'assets/.env');
  WidgetsFlutterBinding.ensureInitialized();

  final omdkApi = OMDKApi(apiEndpoint: dotenv.env['API_ENDPOINT']);
  final omdkLocalData = OMDKLocalData();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

//Setting SystmeUIMode
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  await bootstrap(omdkApi: omdkApi, omdkLocalData: omdkLocalData);
}
