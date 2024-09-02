import 'package:dartz/dartz.dart';

import '../../core/features/errors/custom_exception.dart';
import '../entities/character_overview_entity.dart';
import '../repository/marvel_character_repository.dart';

class GetCharacterByIdUsecase {
  final MarvelCharacterRepository _repository;

  GetCharacterByIdUsecase(this._repository);

  Future<Either<CustomException, CharacterOverviewEntity>> call(
          {required int id}) async =>
      _repository.getCharacterById(id);
}
