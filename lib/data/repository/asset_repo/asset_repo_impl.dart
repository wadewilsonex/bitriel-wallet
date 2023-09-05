import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/index.dart';

class AppRepoImpl implements AppRepository {

  @override
  Future<Response> downloadAsset({String? fileName}) async {
    return await GetRequest.downloadFile(fileName!);
  }
}