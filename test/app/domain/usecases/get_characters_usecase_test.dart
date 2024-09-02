import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:im_mottu_mobile/app/domain/repository/marvel_character_repository.dart';
import 'package:im_mottu_mobile/app/domain/usecases/get_characters_usecase.dart';

import '../../../mocks/character_preview_entity_mock.dart';

class MockMarvelCharacterRepository extends Mock implements MarvelCharacterRepository {}

void main() {
  late GetCharactersUsecase usecase;
  late MockMarvelCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockMarvelCharacterRepository();
    usecase = GetCharactersUsecase(mockRepository);
  });

  const offset = 0;
  final characters = CharacterPreviewEntityMock.list;

  test('should return a list of CharacterPreviewEntity from the repository', () async {
    when(() => mockRepository.getCharacters(offset)).thenAnswer((_) async => Right(characters));

    final result = await usecase.call(offset: offset);

    expect(result, Right(characters));
    verify(() => mockRepository.getCharacters(offset)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a CustomException when the repository fails', () async {
    final cException = CustomException('Failed to load characters', 500);
    when(() => mockRepository.getCharacters(offset)).thenAnswer((_) async => Left(cException));

    final result = await usecase(offset: offset);

    expect(result, Left(cException));
    verify(() => mockRepository.getCharacters(offset)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
