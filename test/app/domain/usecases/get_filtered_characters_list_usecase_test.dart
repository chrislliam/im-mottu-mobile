import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:im_mottu_mobile/app/domain/enum/character_by_content_type.dart';
import 'package:im_mottu_mobile/app/domain/repository/marvel_character_repository.dart';
import 'package:im_mottu_mobile/app/domain/usecases/get_filtered_characters_list_usecase.dart';

import '../../../mocks/character_preview_entity_mock.dart';

class MockMarvelCharacterRepository extends Mock
    implements MarvelCharacterRepository {}

void main() {
  late GetFilteredCharactersListUsecase usecase;
  late MockMarvelCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockMarvelCharacterRepository();
    usecase = GetFilteredCharactersListUsecase(mockRepository);
  });

  const contentType = CharacterByContentType.comics;
  const characterId = 101;
  const offset = 0;
  final tCharacters = CharacterPreviewEntityMock.list;

  test(
      'should return a list of CharacterPreviewEntity based on the filter from the repository',
      () async {
    when(() => mockRepository.getFilteredLCharactersList(
            contentType, characterId, offset))
        .thenAnswer((_) async => Right(tCharacters));

    final result =
        await usecase(filter: contentType, id: characterId, offset: offset);

    expect(result, Right(tCharacters));
    verify(() => mockRepository.getFilteredLCharactersList(
        contentType, characterId, offset)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a CustomException when the repository fails', () async {
    final cException = CustomException('Failed to load characters', 500);
    when(() => mockRepository.getFilteredLCharactersList(
            contentType, characterId, offset))
        .thenAnswer((_) async => Left(cException));
    final result =
        await usecase(filter: contentType, id: characterId, offset: offset);
    expect(result, Left(cException));
    verify(() => mockRepository.getFilteredLCharactersList(
        contentType, characterId, offset)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
