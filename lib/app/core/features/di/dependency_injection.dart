import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/datasources/marvel_character_datasource.dart';
import '../../../data/repository/marvel_character_repository_impl.dart';
import '../../../domain/repository/marvel_character_repository.dart';
import '../../../domain/usecases/get_character_by_id_usecase.dart';
import '../../../domain/usecases/get_characters_usecase.dart';
import '../../../domain/usecases/get_filtered_characters_list_usecase.dart';
import '../../../domain/usecases/search_characters_usecase.dart';
import '../../../presentation/controllers/marvel_character_controler.dart';
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
    Get.lazyPut<GetCharactersUsecase>(
      () => GetCharactersUsecase(Get.find<MarvelCharacterRepository>()),
    );
    Get.lazyPut<SearchCharactersUsecase>(
      () => SearchCharactersUsecase(Get.find<MarvelCharacterRepository>()),
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
    Get.lazyPut<HomePageController>(
      () => HomePageController(Get.find<GetCharactersUsecase>()),
    );
  }
}
