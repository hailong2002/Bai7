import 'package:get/get.dart';
import 'package:timesheet/data/repository/splash_repo.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo repo;

  SplashController({required this.repo});

  final bool _hasConnection = true;

  bool get hasConnection => _hasConnection;

  final String _version = "";

  String get version => _version;

  Future<bool> isUpdateVersion() async {
    // Response response = await repo.getConfig();
    // if (response.statusCode == 200) {
    //   ConfigResponse _data = ConfigResponse.fromJson(response.body);
    //   return _data.versionName == AppConstants.APP_VERSION;
    // } else {
    //   return false;
    // }
    return true;
  }
}
