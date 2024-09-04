import 'package:dartz/dartz.dart';
import '../../core/features/errors/custom_exception.dart';
import '../../domain/entities/character_overview_entity.dart';
import '../../domain/entities/character_preview_entity.dart';
import '../../domain/enum/character_by_content_type.dart';
import '../../domain/repository/marvel_character_repository.dart';
import '../datasources/marvel_character_datasource.dart';

class MarvelCharacterRepositoryImpl implements MarvelCharacterRepository {
  final MarvelCharacterDataSource _datasource;

  MarvelCharacterRepositoryImpl(this._datasource);

  @override
  Future<Either<CustomException, CharacterOverviewEntity>> getCharacterById(
      int id) async {
    try {
      final character = await _datasource.getCharacterById(id);
      return Right(character);
    } on CustomException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomException(e.toString(), null));
    }
  }

  @override
  Future<Either<CustomException, List<CharacterPreviewEntity>>> fetchCharacters(
      int offset, String name) async {
    try {
      final list = await _datasource.fetchCharacters(offset, name);
      return Right(list);
    } on CustomException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomException(e.toString(), null));
    }
  }

  @override
  Future<Either<CustomException, List<CharacterPreviewEntity>>>
      getFilteredLCharactersList(
          CharacterByContentType filter, int id, offset) async {
    try {
      final list =
          await _datasource.getFilteredLCharactersList(filter, id, offset);
      return Right(list);
    } on CustomException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CustomException(e.toString(), null));
    }
  }
}
