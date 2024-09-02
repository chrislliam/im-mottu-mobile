import 'package:dartz/dartz.dart';

import '../../core/features/errors/custom_exception.dart';
import '../entities/character_preview_entity.dart';
import '../repository/marvel_character_repository.dart';

class GetCharactersUsecase {
  final MarvelCharacterRepository _repository;

  GetCharactersUsecase(this._repository);

  Future<Either<CustomException, List<CharacterPreviewEntity>>> call(
          {required int offset}) async =>
      _repository.getCharacters(offset);
}
