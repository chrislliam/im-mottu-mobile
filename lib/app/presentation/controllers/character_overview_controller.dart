import 'package:get/get.dart';
import '../../core/features/errors/custom_exception.dart';
import '../../domain/entities/character_overview_entity.dart';
import '../../domain/entities/character_preview_entity.dart';
import '../../domain/enum/character_by_content_type.dart';
import '../../domain/usecases/get_character_by_id_usecase.dart';
import '../../domain/usecases/get_filtered_characters_list_usecase.dart';
import '../states/character_overview_page_state.dart';

class CharacterOverviewController extends GetxController {
  final GetCharacterByIdUsecase _getCharacterByIdUsecase;
  final GetFilteredCharactersListUsecase _getFilteredCharactersListUsecase;
  CharacterOverviewController(
      this._getCharacterByIdUsecase, this._getFilteredCharactersListUsecase);

  final pageState =
      Rx<CharacterOverviewPageState>(CharacterOverviewPageLoading());

  final selectedFilter = CharacterByContentType.comics.obs;

  final isLoadingRelatedCharacters = false.obs;

  final relatedCharactersList = Rx<List<CharacterPreviewEntity>>([]);

  Future<void> initialize({required int characterId}) async {
    pageState(CharacterOverviewPageLoading());

    try {
      final character = await _loadCharacter(characterId);
      await onFilterSelected(selectedFilter.value, character);
      _characterHistory.add(character);
      pageState(CharacterOverviewPageSuccess(character));
    } on CustomException catch (e) {
      pageState(CharacterOverviewPageError(e.message));
    } catch (e) {
      pageState(CharacterOverviewPageError(e.toString()));
    }
  }

  Future<void> onFilterSelected(
      CharacterByContentType filter, CharacterOverviewEntity character) async {
    selectedFilter(filter);
    isLoadingRelatedCharacters(true);

    final result = await _getFilteredCharactersListUsecase(
        filter: filter, id: character.idByType(filter), offset: 0);
    result.fold(
      (error) => throw error,
      (characters) => relatedCharactersList(characters),
    );
    await Future.delayed(const Duration(seconds: 2));

    isLoadingRelatedCharacters(false);
  }

  Future<CharacterOverviewEntity> _loadCharacter(int characterId) async {
    try {
      final result = await _getCharacterByIdUsecase(id: characterId);
      return result.fold(
        (error) => throw error,
        (character) => character,
      );
    } catch (e) {
      rethrow;
    }
  }

  final List<CharacterOverviewEntity?> _characterHistory = [];

  void pushCharacter(int characterId) async {
    try {
      final charIdToCheck = characterId;
      final existingChar = _characterHistory
          .firstWhere((char) => char!.id == charIdToCheck, orElse: () => null);

      if (existingChar != null) {
        _characterHistory.add(existingChar);
        pageState(CharacterOverviewPageSuccess(existingChar));
        await onFilterSelected(selectedFilter.value, existingChar);
      } else {
        final value = await _loadCharacter(characterId);
        _characterHistory.add(value);
        pageState(CharacterOverviewPageSuccess(value));
        await onFilterSelected(selectedFilter.value, value);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> popCharacterOverview() async {
    try {
      _characterHistory.removeLast();

      if (_characterHistory.isNotEmpty) {
        pageState(CharacterOverviewPageLoading());
        await onFilterSelected(selectedFilter.value, _characterHistory.last!);
        pageState(CharacterOverviewPageSuccess(_characterHistory.last!));
      } else {
        Get.back();
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(true);
    }
  }
}
