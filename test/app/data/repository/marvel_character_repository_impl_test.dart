import 'package:flutter_test/flutter_test.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:im_mottu_mobile/app/data/datasources/marvel_character_datasource.dart';
import 'package:im_mottu_mobile/app/data/repository/marvel_character_repository_impl.dart';
import 'package:im_mottu_mobile/app/domain/enum/character_by_content_type.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mocks/character_overview_entity_mock.dart';
import '../../../mocks/character_preview_entity_mock.dart';

class MockMarvelCharacterDataSource extends Mock implements MarvelCharacterDataSource {}

void main() {
  late MarvelCharacterRepositoryImpl repository;
  late MockMarvelCharacterDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMarvelCharacterDataSource();
    repository = MarvelCharacterRepositoryImpl(mockDataSource);
  });

  group('MarvelCharacterRepositoryImpl: Exceptions tests', () {
    test('should return CustomException when getCharacterById throws CustomException', () async {
      when(() => mockDataSource.getCharacterById(1)).thenThrow(CustomException('Error', null));

      final result = await repository.getCharacterById(1);
      final value = result.fold((l) => l, (r) => r);

      expect(value, isA<CustomException>());
    });

    test('should return CustomException when searchCharacters throws CustomException', () async {
      when(() => mockDataSource.searchCharacters('Spider')).thenThrow(CustomException('Error', null));

      final result = await repository.searchCharacters('Spider');

      final value = result.fold((l) => l, (r) => r);
      expect(value, isA<CustomException>());
    });

    test('should return CustomException when getCharacters throws CustomException', () async {
      when(() => mockDataSource.getCharacters(1)).thenThrow(CustomException('Error', null));

      final result = await repository.getCharacters(1);
      final value = result.fold((l) => l, (r) => r);

      expect(value, isA<CustomException>());
    });

    test('should return CustomException when getFilteredLCharactersList throws CustomException', () async {
      when(() => mockDataSource.getFilteredLCharactersList(CharacterByContentType.comics, 1, 0))
          .thenThrow(CustomException('Error', null));

      final result = await repository.getFilteredLCharactersList(CharacterByContentType.comics, 1, 0);
      final value = result.fold((l) => l, (r) => r);

      expect(value, isA<CustomException>());
    });
  });

  group('MarvelCharacterRepositoryImpl: Success test', () {
    final characterPreview = CharacterPreviewEntityMock.spiderMan;
    final characterOverview = CharacterOverviewEntityMock.characterOverviewEntity;
    test('should return CharacterOverviewEntity when getCharacterById is called', () async {
      when(() => mockDataSource.getCharacterById(1)).thenAnswer((_) async => characterOverview);

      final result = await repository.getCharacterById(1);

      expect(result, Right(characterOverview));
    });

    test('should return List<CharacterPreviewEntity> when getCharacters is called', () async {
      when(() => mockDataSource.getCharacters(0)).thenAnswer((_) async => [characterPreview]);

      final result = await repository.getCharacters(0);
      expect(result, isA<Right>());
      result.fold((l) => null, (r) {
        expect(r, [characterPreview]);
      });
    });

    test('should return List<CharacterPreviewEntity> when getFilteredLCharactersList is called', () async {
      when(() => mockDataSource.getFilteredLCharactersList(CharacterByContentType.comics, 1, 0))
          .thenAnswer((_) async => [characterPreview]);

      final result = await repository.getFilteredLCharactersList(CharacterByContentType.comics, 1, 0);

      expect(result, isA<Right>());
      result.fold((l) => null, (r) {
        expect(r, [characterPreview]);
      });
    });
    test('should return List<CharacterPreviewEntity> when searchCharacters is called', () async {
      when(() => mockDataSource.searchCharacters('Spider')).thenAnswer((_) async => [characterPreview]);

      final result = await repository.searchCharacters('Spider');
      expect(result, isA<Right>());
      result.fold((l) => null, (r) {
        expect(r, [characterPreview]);
      });
    });
  });
}
