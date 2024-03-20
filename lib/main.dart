import 'package:omdk/bootstrap.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:opera_api_auth/opera_api_auth.dart';

Future<void> main() async {

  final omdkApi = OMDKApi();
  final AuthApi authApi = OperaApiAuth(omdkApi.client);
  final omdkLocalData = OMDKLocalData(omdkApi, authApi);

  bootstrap(omdkApi: omdkApi, omdkLocalData: omdkLocalData);
}
