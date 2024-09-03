import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/character_overview_controller.dart';
import '../states/character_overview_page_state.dart';
import '../widgets/related_characters_widget.dart';

class CharacterOverviewPage extends StatefulWidget {
  const CharacterOverviewPage({super.key});

  @override
  State<CharacterOverviewPage> createState() => _CharacterOverviewPageState();
}

class _CharacterOverviewPageState extends State<CharacterOverviewPage> {
  late final CharacterOverviewController controller;
  final int characterId = Get.arguments as int;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CharacterOverviewController>();
    controller.initialize(characterId: characterId);
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: controller.popCharacterOverview,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async => await controller.popCharacterOverview(),
                icon: const Icon(Icons.arrow_back)),
            title: const Text('Detalhes do personagem'),
          ),
          body: Obx(() {
            final state = controller.pageState.value;

            switch (state) {
              case CharacterOverviewPageLoading():
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFFC8102E)),
                  ),
                );
              case CharacterOverviewPageSuccess():
                final character = state.character;

                return Padding(
                  padding: const EdgeInsets.all(21),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              character.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Image(
                                    image: NetworkImage(character.thumbnail))),
                            RichText(
                                text: TextSpan(
                                    text: 'Descrição\n',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    children: [
                                  TextSpan(
                                    text: character.description.isEmpty
                                        ? '\nSem descrição'
                                        : '\n${character.description}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ])),
                          ],
                        ),
                      ),
                      RelatedCharactersWidget(
                          key: Key('$runtimeType${character.id}'),
                          selectedFilter: controller.selectedFilter.value,
                          onFilterSelected: (value) =>
                              controller.onFilterSelected(value, character),
                          isLoading:
                              controller.isLoadingRelatedCharacters.value,
                          relatedCharacters:
                              controller.relatedCharactersList.value)
                    ],
                  ),
                );
              case CharacterOverviewPageError():
                return Center(
                  child: Text('Atenção: ${state.message}'),
                );
            }
          })),
    );
  }
}
