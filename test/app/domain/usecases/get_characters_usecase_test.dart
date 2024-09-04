import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:im_mottu_mobile/app/domain/repository/marvel_character_repository.dart';
import 'package:im_mottu_mobile/app/domain/usecases/fetch_characters_usecase.dart';

import '../../../mocks/character_preview_entity_mock.dart';

class MockMarvelCharacterRepository extends Mock
    implements MarvelCharacterRepository {}

void main() {
  late FetchCharactersUsecase usecase;
  late MockMarvelCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockMarvelCharacterRepository();
    usecase = FetchCharactersUsecase(mockRepository);
  });

  const offset = 0;
  final characters = CharacterPreviewEntityMock.list;
  const searchName = 'Spider';

  test('should return a list of CharacterPreviewEntity from the repository',
      () async {
    when(() => mockRepository.fetchCharacters(offset, searchName))
        .thenAnswer((_) async => Right(characters));

    final result = await usecase(offset: offset, name: searchName);

    expect(result, Right(characters));
    verify(() => mockRepository.fetchCharacters(offset, searchName)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a CustomException when the repository fails', () async {
    final cException = CustomException('Failed to load characters', 500);
    when(() => mockRepository.fetchCharacters(offset, searchName))
        .thenAnswer((_) async => Left(cException));

    final result = await usecase(offset: offset, name: searchName);

    expect(result, Left(cException));
    verify(() => mockRepository.fetchCharacters(offset, searchName)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
