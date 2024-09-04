import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/datasources/marvel_character_datasource.dart';
import '../../../data/repository/marvel_character_repository_impl.dart';
import '../../../domain/repository/marvel_character_repository.dart';
import '../../../domain/usecases/get_character_by_id_usecase.dart';
import '../../../domain/usecases/fetch_characters_usecase.dart';
import '../../../domain/usecases/get_filtered_characters_list_usecase.dart';
import '../../../presentation/controllers/character_overview_controller.dart';
import '../../../presentation/controllers/home_page_controller.dart';
import '../../../presentation/controllers/splash_page_controller.dart';
import '../constants/constants.dart';
import '../http_client/http_client.dart';
import '../../network/network_info.dart';
import '../../network/network_info_datasource.dart';

class DependencyInjection {
  static void init() {
    // Core
    Get.lazyPut<CoreHttpClient>(() => DioHttpClient());

    // Datasources
    Get.lazyPut<NetworkInfoDatasource>(
      () => NetworkInfoDatasourceImpl(
        const EventChannel(Constants.connectivityEventChannel),
        const MethodChannel(Constants.connectivityMethodChannel),
      ),
    );

    Get.lazyPut<MarvelCharacterDataSource>(
      () => MarvelCharacterDataSourceImpl(
        Get.find<NetworkInfoDatasource>(),
        Get.find<CoreHttpClient>(),
      ),
    );

    // Repositories
    Get.lazyPut<MarvelCharacterRepository>(
      () =>
          MarvelCharacterRepositoryImpl(Get.find<MarvelCharacterDataSource>()),
    );

    // Use Cases
    Get.lazyPut<FetchCharactersUsecase>(
      () => FetchCharactersUsecase(Get.find<MarvelCharacterRepository>()),
    );
    Get.lazyPut<GetFilteredCharactersListUsecase>(
      () => GetFilteredCharactersListUsecase(
          Get.find<MarvelCharacterRepository>()),
    );
    Get.lazyPut<GetCharacterByIdUsecase>(
      () => GetCharacterByIdUsecase(Get.find<MarvelCharacterRepository>()),
    );

    //Controllers
    Get.lazyPut<NetworkInfo>(
      () => NetworkInfo(Get.find<NetworkInfoDatasource>()),
    );
    Get.lazyPut<SplashPageController>(
      () => SplashPageController(),
    );
    Get.lazyPut<HomePageController>(
      () => HomePageController(Get.find<FetchCharactersUsecase>()),
    );

    Get.put<CharacterOverviewController>(CharacterOverviewController(
      Get.find<GetCharacterByIdUsecase>(),
      Get.find<GetFilteredCharactersListUsecase>(),
    ));
  }
}
