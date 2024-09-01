import 'package:dartz/dartz.dart';

import '../../core/features/errors/custom_exception.dart';
import '../entities/character_preview_entity.dart';
import '../enum/character_by_content_type.dart';
import '../repository/marvel_character_repository.dart';

class GetFilteredCharactersListUsecase {
  final MarvelCharacterRepository _repository;

  GetFilteredCharactersListUsecase(this._repository);

  Future<Either<CustomException, List<CharacterPreviewEntity>>> call(
          {required CharacterByContentType filter,
          required int id,
          required int offset}) async =>
      _repository.getFilteredLCharactersList(filter, id, offset);
}
