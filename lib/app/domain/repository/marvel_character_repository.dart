import 'package:dartz/dartz.dart';
import '../../core/features/errors/custom_exception.dart';
import '../entities/character_overview_entity.dart';
import '../entities/character_preview_entity.dart';
import '../enum/character_by_content_type.dart';

abstract interface class MarvelCharacterRepository {
  Future<Either<CustomException, List<CharacterPreviewEntity>>> getCharacters(
      int offset);

  Future<Either<CustomException, List<CharacterPreviewEntity>>>
      getFilteredLCharactersList(CharacterByContentType filter, int id, offset);

  Future<Either<CustomException, List<CharacterPreviewEntity>>>
      searchCharacters(String name);

  Future<Either<CustomException, CharacterOverviewEntity>> getCharacterById(
      int id);
}
