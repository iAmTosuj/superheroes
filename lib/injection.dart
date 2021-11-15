import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:superheroes/blocs/main_bloc/main_cubit.dart';
import 'package:superheroes/repository/main_page/main_page_repository_impl.dart';
import 'package:superheroes/resources/base_url.dart';

class DependenciesInitializer {
  static Future<void> initializeDependencies() async {
    Dio _createMainClient() {
      final token = dotenv.env['SUPERHERO_TOKEN'];

      final client = Dio(BaseOptions(baseUrl: '${ResBaseUrl.main}/api/$token'));
      client.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
      return client;
    }

    final _mainClient = _createMainClient();
    // cubits
    final _mainCubit =
        MainCubit(mainRepository: MainPageRepositoryImpl(client: _mainClient));

    Get.put(_mainClient);

    Get.put(_mainCubit);
  }
}
