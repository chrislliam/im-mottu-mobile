import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_mottu_mobile/app/presentation/states/home_page_state.dart';

import '../controllers/marvel_character_controler.dart';
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
            return const Center(child: CircularProgressIndicator());

          case HomePageLoaded():
            if (controller.characters.isEmpty) {
              return const Center(child: Text('Nenhum peronagem encontrado'));
            }
            return ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.characters.length + 1,
              itemBuilder: (context, index) {
                if (index < controller.characters.length) {
                  final character = controller.characters[index];
                  return MarvelCharacterCard(
                      key: ValueKey('character${character.id}'),
                      preview: character);
                }
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              },
            );
          case HomePageError():
            return Center(child: Text(state.message));
        }
      }),
    );
  }
}
