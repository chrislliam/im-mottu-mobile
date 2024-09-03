import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';

import '../../domain/entities/character_preview_entity.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import '../states/home_page_state.dart';

class HomePageController extends GetxController {
  final GetCharactersUsecase _charactersUsecase;

  HomePageController(this._charactersUsecase);

  final characters = <CharacterPreviewEntity>[].obs;
  final isLoading = true.obs;

  final pageState = Rx<HomePageState>(HomePageLoading());

  int offset = 0;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initialize();

    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        await _loadCharacters();
      }
    });
  }

  Future<void> initialize() async {
    pageState(HomePageLoading());

    try {
      await _loadCharacters();
      pageState(HomePageLoaded());
    } on CustomException catch (e) {
      pageState(HomePageError(e.message));
    } catch (e) {
      pageState(HomePageError(e.toString()));
    }
  }

  Future<void> _loadCharacters() async {
    try {
      isLoading(true);
      final result = await _charactersUsecase(offset: offset);
      final list = result.fold((l) => throw l, (r) => r);
      if (list.isNotEmpty) {
        final newItems = list.where((character) =>
            !characters.any((existing) => existing.id == character.id));
        characters.addAll(newItems);
        offset = characters.length;
      }
    } on CustomException catch (e) {
      pageState(HomePageError(e.message));
    } catch (e) {
      pageState(HomePageError(e.toString()));
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
