import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:im_mottu_mobile/app/domain/repository/marvel_character_repository.dart';
import 'package:im_mottu_mobile/app/domain/usecases/get_character_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/character_overview_entity_mock.dart';

class MockMarvelCharacterRepository extends Mock
    implements MarvelCharacterRepository {}

void main() {
  late GetCharacterByIdUsecase usecase;
  late MockMarvelCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockMarvelCharacterRepository();
    usecase = GetCharacterByIdUsecase(mockRepository);
  });

  const characterId = 1;
  final characterOveview = CharacterOverviewEntityMock.characterOverviewEntity;

  test('should get character overview from the repository', () async {
    when(() => mockRepository.getCharacterById(characterId))
        .thenAnswer((_) async => Right(characterOveview));

    final result = await usecase(id: characterId);

    expect(result, Right(characterOveview));

    verify(() => mockRepository.getCharacterById(characterId)).called(1);

    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CustomException when there is an error', () async {
    final cException = CustomException('Error message', 404);
    when(() => mockRepository.getCharacterById(characterId))
        .thenAnswer((_) async => Left(cException));

    final result = await usecase(id: characterId);
    expect(result, Left(cException));
    verify(() => mockRepository.getCharacterById(characterId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
