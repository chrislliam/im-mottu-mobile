import 'package:flutter_test/flutter_test.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';
import 'package:im_mottu_mobile/app/data/datasources/marvel_character_datasource.dart';
import 'package:im_mottu_mobile/app/data/repository/marvel_character_repository_impl.dart';
import 'package:im_mottu_mobile/app/domain/entities/character_overview_entity.dart';
import 'package:im_mottu_mobile/app/domain/entities/character_preview_entity.dart';
import 'package:im_mottu_mobile/app/domain/enum/character_by_content_type.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockMarvelCharacterDataSource extends Mock
    implements MarvelCharacterDataSource {}

void main() {
  late MarvelCharacterRepositoryImpl repository;
  late MockMarvelCharacterDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMarvelCharacterDataSource();
    repository = MarvelCharacterRepositoryImpl(mockDataSource);
  });

  group('MarvelCharacterRepositoryImpl', () {
    const int testId = 1;
    const int testOffset = 0;
    const String testName = 'Spider-Man';

    test(
        'should return CharacterOverviewEntity when getCharacterById is called',
        () async {
      final character = CharacterOverviewEntity(
          id: testId,
          name: 'Spider-Man',
          thumbnail: 'thumbnail.png',
          description: 'Description');

      when(() => mockDataSource.getCharacterById(testId))
          .thenAnswer((_) async => character);

      final result = await repository.getCharacterById(testId);

      expect(result, Right(character));
    });

    test(
        'should return CustomException when getCharacterById throws CustomException',
        () async {
      final exception = CustomException('Error', 404);

      when(() => mockDataSource.getCharacterById(testId)).thenThrow(exception);

      final result = await repository.getCharacterById(testId);

      expect(result, Left(exception));
    });

    test(
        'should return CustomException when getCharacterById throws an unexpected error',
        () async {
      when(() => mockDataSource.getCharacterById(testId))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.getCharacterById(testId);

      expect(result, isA<Left<CustomException, CharacterOverviewEntity>>());
    });

    test(
        'should return a list of CharacterPreviewEntity when getCharacters is called',
        () async {
      final characterList = [
        CharacterPreviewEntity(
            id: testId, name: 'Spider-Man', thumbnail: 'thumbnail.png')
      ];

      when(() => mockDataSource.getCharacters(testOffset))
          .thenAnswer((_) async => characterList);

      final result = await repository.getCharacters(testOffset);

      expect(result, Right(characterList));
    });

    test(
        'should return CustomException when getCharacters throws CustomException',
        () async {
      final exception = CustomException('Error', 404);

      when(() => mockDataSource.getCharacters(testOffset)).thenThrow(exception);

      final result = await repository.getCharacters(testOffset);

      expect(result, Left(exception));
    });

    test(
        'should return CustomException when getCharacters throws an unexpected error',
        () async {
      when(() => mockDataSource.getCharacters(testOffset))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.getCharacters(testOffset);

      expect(
          result, isA<Left<CustomException, List<CharacterPreviewEntity>>>());
    });

    test(
        'should return filtered characters list when getFilteredLCharactersList is called',
        () async {
      final characterList = [
        CharacterPreviewEntity(
            id: testId, name: 'Spider-Man', thumbnail: 'thumbnail.png')
      ];

      when(() => mockDataSource.getFilteredLCharactersList(
              CharacterByContentType.comics, testId, testOffset))
          .thenAnswer((_) async => characterList);

      final result = await repository.getFilteredLCharactersList(
          CharacterByContentType.comics, testId, testOffset);

      expect(result, Right(characterList));
    });

    test(
        'should return CustomException when getFilteredLCharactersList throws CustomException',
        () async {
      final exception = CustomException('Error', 404);

      when(() => mockDataSource.getFilteredLCharactersList(
              CharacterByContentType.comics, testId, testOffset))
          .thenThrow(exception);

      final result = await repository.getFilteredLCharactersList(
          CharacterByContentType.comics, testId, testOffset);

      expect(result, Left(exception));
    });

    test(
        'should return CustomException when getFilteredLCharactersList throws an unexpected error',
        () async {
      when(() => mockDataSource.getFilteredLCharactersList(
              CharacterByContentType.comics, testId, testOffset))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.getFilteredLCharactersList(
          CharacterByContentType.comics, testId, testOffset);

      expect(
          result, isA<Left<CustomException, List<CharacterPreviewEntity>>>());
    });

    test(
        'should return a list of CharacterPreviewEntity when searchCharacters is called',
        () async {
      final characterList = [
        CharacterPreviewEntity(
            id: testId, name: 'Spider-Man', thumbnail: 'thumbnail.png')
      ];

      when(() => mockDataSource.searchCharacters(testName))
          .thenAnswer((_) async => characterList);

      final result = await repository.searchCharacters(testName);

      expect(result, Right(characterList));
    });

    test(
        'should return CustomException when searchCharacters throws CustomException',
        () async {
      final exception = CustomException('Error', 404);

      when(() => mockDataSource.searchCharacters(testName))
          .thenThrow(exception);

      final result = await repository.searchCharacters(testName);

      expect(result, Left(exception));
    });

    test(
        'should return CustomException when searchCharacters throws an unexpected error',
        () async {
      when(() => mockDataSource.searchCharacters(testName))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.searchCharacters(testName);

      expect(
          result, isA<Left<CustomException, List<CharacterPreviewEntity>>>());
    });
  });
}
