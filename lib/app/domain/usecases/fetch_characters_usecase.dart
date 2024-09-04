import 'package:dartz/dartz.dart';

import '../../core/features/errors/custom_exception.dart';
import '../entities/character_preview_entity.dart';
import '../repository/marvel_character_repository.dart';

class FetchCharactersUsecase {
  final MarvelCharacterRepository _repository;

  FetchCharactersUsecase(this._repository);

  Future<Either<CustomException, List<CharacterPreviewEntity>>> call(
          {required int offset, required String name}) async =>
      _repository.fetchCharacters(offset, name);
}
