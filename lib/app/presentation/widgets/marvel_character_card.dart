import 'package:flutter/material.dart';

import '../../core/features/routes/app_navigator.dart';
import '../../domain/entities/character_preview_entity.dart';

class MarvelCharacterCard extends StatelessWidget {
  final CharacterPreviewEntity preview;
  const MarvelCharacterCard({super.key, required this.preview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            preview.thumbnail,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          preview.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: InkWell(
          onTap: () => AppNavigator.characterOverview(characterId: preview.id),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 232, 240, 247),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.info_outline,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
