import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/character_preview_entity.dart';
import '../../domain/enum/character_by_content_type.dart';
import '../controllers/character_overview_controller.dart';

class RelatedCharactersWidget extends StatelessWidget {
  final CharacterByContentType selectedFilter;
  final void Function(CharacterByContentType) onFilterSelected;
  final List<CharacterPreviewEntity> relatedCharacters;
  final bool isLoading;
  const RelatedCharactersWidget(
      {super.key,
      required this.selectedFilter,
      required this.onFilterSelected,
      required this.relatedCharacters,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CharacterOverviewController>();
    return Column(
      children: [
        const Text(
          'Personagens relacionados',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CharacterByContentType.values.length,
            itemBuilder: (context, index) {
              final character = CharacterByContentType.values[index];
              final isSelected = selectedFilter == character;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: InputChip(
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    selected: isSelected,
                    selectedColor: const Color(0xFFC8102E),
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600]!),
                    side: BorderSide(
                      color:
                          isSelected ? const Color(0xFFC8102E) : Colors.white,
                    ),
                    label: Text(
                      character.label,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onSelected: (selected) => onFilterSelected(character)),
              );
            },
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 80),
          child: isLoading
              ? const Center(
                  child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFFC8102E)),
                ))
              : relatedCharacters.isEmpty
                  ? const Center(
                      child: Text('Não há personagens relacionados'),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedCharacters.length,
                      itemBuilder: (context, index) {
                        final char = relatedCharacters[index];
                        return InkWell(
                          onTap: () => controller.pushCharacter(char.id),
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: ClipOval(
                              child: Image.network(
                                char.thumbnail,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
