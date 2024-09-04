import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_mottu_mobile/app/core/features/errors/custom_exception.dart';

import '../../domain/entities/character_preview_entity.dart';
import '../../domain/usecases/fetch_characters_usecase.dart';
import '../states/home_page_state.dart';

class HomePageController extends GetxController {
  final FetchCharactersUsecase _charactersUsecase;

  HomePageController(this._charactersUsecase);

  final characters = <CharacterPreviewEntity>[].obs;
  final isLoading = true.obs;

  final isSearching = false.obs;

  final searchController = TextEditingController();

  final pageState = Rx<HomePageState>(HomePageLoading());

  int offset = 0;
  final ScrollController scrollController = ScrollController();

  Timer? _debounce;
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

  Future<void> search(String search) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (isSearching.value) {
        return;
      }
      try {
        isSearching(true);
        characters.clear();
        offset = 0;

        final result = await _charactersUsecase(
            offset: offset, name: searchController.text);
        final list = result.fold((l) => throw l, (r) => r);
        final newItems = list.where((character) =>
            !characters.any((existing) => existing.id == character.id));
        characters.addAll(newItems);
        offset = characters.length;
      } on CustomException catch (e) {
        pageState(HomePageError(e.message));
      } catch (e) {
        pageState(HomePageError(e.toString()));
      } finally {
        isSearching(false);
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
      final result =
          await _charactersUsecase(offset: offset, name: searchController.text);
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
