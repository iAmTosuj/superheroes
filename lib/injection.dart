import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:superheroes/resources/base_url.dart';

class DependenciesInitializer {
  static Future<void> initializeDependencies() async {
    Dio _createMainClient() {
      final client = Dio(BaseOptions(baseUrl: '${ResBaseUrl.main}/'));

      return client;
    }

    final _mainClient = _createMainClient();

    Get.put(_mainClient);
  }
}
