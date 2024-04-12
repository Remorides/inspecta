import 'package:flutter/cupertino.dart';
import 'package:omdk/bootstrap.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final omdkApi = OMDKApi();
  final omdkLocalData = OMDKLocalData();

  bootstrap(omdkApi: omdkApi, omdkLocalData: omdkLocalData);
}
