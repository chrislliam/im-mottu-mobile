import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_mottu_mobile/app/presentation/states/home_page_state.dart';

import '../controllers/home_page_controller.dart';
import '../widgets/marvel_character_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState() {
    controller = Get.find<HomePageController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Characters'),
      ),
      body: Obx(() {
        final state = controller.pageState.value;

        switch (state) {
          case HomePageLoading():
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC8102E)),
            ));

          case HomePageLoaded():
            return Column(
              children: [
                _CustomTextField(
                  search: controller.search,
                  searchController: controller.searchController,
                ),
                Expanded(
                  child: controller.isSearching.value
                      ? const Center(
                          child: Text(
                          'Pesquisando...',
                          style: TextStyle(fontSize: 20),
                        ))
                      : controller.characters.isEmpty
                          ? const Center(child: Text('Nenhum peronagem encontrado'))
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              separatorBuilder: (context, index) => const SizedBox(height: 24),
                              controller: controller.scrollController,
                              itemCount: controller.characters.length + 1,
                              itemBuilder: (context, index) {
                                if (index < controller.characters.length) {
                                  final character = controller.characters[index];
                                  return MarvelCharacterCard(
                                      key: ValueKey('character${character.id}'), preview: character);
                                }
                                return controller.isLoading.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : const SizedBox.shrink();
                              },
                            ),
                ),
              ],
            );
          case HomePageError():
            return Center(child: Text(state.message));
        }
      }),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController searchController;

  final void Function(String) search;

  const _CustomTextField({
    required this.searchController,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        onChanged: search,
        decoration: InputDecoration(
          hintText: 'Ex: Spider-Man, iron man...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    search('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFC8102E)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFC8102E), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
