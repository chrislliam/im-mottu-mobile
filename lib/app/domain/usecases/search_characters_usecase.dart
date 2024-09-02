import 'package:dartz/dartz.dart';

import '../../core/features/errors/custom_exception.dart';
import '../entities/character_preview_entity.dart';
import '../repository/marvel_character_repository.dart';

class SearchCharactersUsecase {
  final MarvelCharacterRepository _repository;

  SearchCharactersUsecase(this._repository);

  Future<Either<CustomException, List<CharacterPreviewEntity>>> call(
          {required String name}) async =>
      _repository.searchCharacters(name);
}
