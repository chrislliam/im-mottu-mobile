import 'package:im_mottu_mobile/app/domain/entities/character_preview_entity.dart';

class CharacterPreviewEntityMock {
  static List<CharacterPreviewEntity> list = [
    CharacterPreviewEntity(
      id: 1,
      name: 'Homem Aranha (Tobey Maguire)',
      thumbnail: 'spiderman_thumbnail.jpg',
    ),
    CharacterPreviewEntity(
      id: 2,
      name: 'Wolverine',
      thumbnail: 'wolverine_thumbnail.jpg',
    ),
    CharacterPreviewEntity(
      id: 3,
      name: 'Homem de Ferro',
      thumbnail: 'ironman_thumbnail.jpg',
    ),
    CharacterPreviewEntity(
      id: 4,
      name: 'Capitão América',
      thumbnail: 'captainamerica_thumbnail.jpg',
    ),
    CharacterPreviewEntity(
      id: 5,
      name: 'Thor',
      thumbnail: 'thor_thumbnail.jpg',
    ),
  ];

  static CharacterPreviewEntity get firstCharacterPreview => list[0];
  static CharacterPreviewEntity get spiderMan => list[0];
}
