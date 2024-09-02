import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:im_mottu_mobile/app/domain/repository/marvel_character_repository.dart';
import 'package:im_mottu_mobile/app/domain/usecases/search_characters_usecase.dart';

import '../../../mocks/character_preview_entity_mock.dart';

class MockMarvelCharacterRepository extends Mock
    implements MarvelCharacterRepository {}

void main() {
  late SearchCharactersUsecase usecase;
  late MockMarvelCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockMarvelCharacterRepository();
    usecase = SearchCharactersUsecase(mockRepository);
  });

  const nameToSearch = 'Homem Aranha';
  final characterList = [CharacterPreviewEntityMock.firstCharacterPreview];

  test(
      'should return a list of CharacterPreviewEntity based on the name from the repository',
      () async {
    when(() => mockRepository.searchCharacters(nameToSearch))
        .thenAnswer((_) async => Right(characterList));

    final result = await usecase(name: nameToSearch);

    expect(result, Right(characterList));
    verify(() => mockRepository.searchCharacters(nameToSearch)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a CustomException when the repository fails', () async {
    final cException = CustomException('Failed to search characters', 500);
    when(() => mockRepository.searchCharacters(nameToSearch))
        .thenAnswer((_) async => Left(cException));

    final result = await usecase(name: nameToSearch);

    expect(result, Left(cException));
    verify(() => mockRepository.searchCharacters(nameToSearch)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
