import '../../core/features/constants/constants.dart';
import '../../core/features/errors/custom_exception.dart';
import '../../core/features/http_client/http_client.dart';
import '../../core/features/local_storage/local_storage.dart';
import '../../core/network/network_info_datasource.dart';
import '../../domain/entities/character_overview_entity.dart';
import '../../domain/entities/character_preview_entity.dart';
import '../../domain/enum/character_by_content_type.dart';
import '../adapters/character_overview_adapter.dart';
import '../adapters/character_preview_adapter.dart';

abstract interface class MarvelCharacterDataSource {
  Future<List<CharacterPreviewEntity>>fetchCharacters(int offset, String name);

  Future<List<CharacterPreviewEntity>> getFilteredLCharactersList(
      CharacterByContentType filter, int id, int offset);

  Future<CharacterOverviewEntity> getCharacterById(int id);
}

class MarvelCharacterDataSourceImpl implements MarvelCharacterDataSource {
  final NetworkInfoDatasource _networkInfo;
  final CoreHttpClient _client;

  MarvelCharacterDataSourceImpl(this._networkInfo, this._client);

  @override
  Future<CharacterOverviewEntity> getCharacterById(int id) async {
    try {
      final getCharacterInLocal =
          await LocalStorage.getCache(Constants.characters, id);

      if (getCharacterInLocal != null) {
        return CharacterOverviewAdapter.fromJson(getCharacterInLocal);
      } else {
        final isConnected = await _networkInfo.isConnected;
        if (isConnected) {
          final response = await _client.get('/characters/$id');
          if (response.statusCode == 200) {
            return CharacterOverviewAdapter.fromJson(
                response.data['data']['results'][0]);
          } else {
            throw CustomException(
                response.data['data']['message'], response.statusCode);
          }
        }
        throw CustomException('Sem conexão à internet', null);
      }
    } catch (e) {
      throw CustomException(e.toString(), null);
    }
  }

  @override
  Future<List<CharacterPreviewEntity>> fetchCharacters(int offset, String name) async {
    try {
      var list = <CharacterPreviewEntity>[];
      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        final response = await _client
            .get('characters', queryParameters: {'offset': offset,
         if(name.isNotEmpty)   'nameStartsWith': name
            
            });

        if (response.statusCode == 200) {
          final results = response.data['data']['results'] as List;
          list = CharacterPreviewAdapter.fromJsonList(results);
          await LocalStorage.saveCache(Constants.characters, results);
        } else {
          throw CustomException(
              response.data['data']['message'], response.statusCode);
        }
      } else {
        final results = await LocalStorage.getCache<List>(Constants.characters);
        list = CharacterPreviewAdapter.fromJsonList(results);
      }
      return list;
    } catch (e) {
      throw CustomException(e.toString(), null);
    }
  }

  @override
  Future<List<CharacterPreviewEntity>> getFilteredLCharactersList(
      CharacterByContentType filter, int id, int offset) async {
    try {
      var list = <CharacterPreviewEntity>[];
      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        if (id == 0) {
          return list;
        }
        final response = await _client.get('${filter.name}/$id/characters',
            queryParameters: {'offset': offset});

        if (response.statusCode == 200) {
          final results = response.data['data']['results'] as List;
          list = CharacterPreviewAdapter.fromJsonList(results);
          await LocalStorage.saveCache(Constants.characters, results);
        } else {
          throw CustomException(
              response.data['data']['message'], response.statusCode);
        }
      } else {
        final results = await LocalStorage.getCache<List>(Constants.characters);
        list = CharacterPreviewAdapter.fromJsonList(results);
      }
      return list;
    } catch (e) {
      throw CustomException(e.toString(), null);
    }
  }

}
