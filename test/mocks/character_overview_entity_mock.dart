import 'package:im_mottu_mobile/app/domain/entities/character_overview_entity.dart';

class CharacterOverviewEntityMock {
  static List<CharacterOverviewEntity> list = [
    CharacterOverviewEntity(
      description: 'Não é problema meu',
      id: 1,
      firstEncounter: CharacterFirstEncounter(
        firstComicId: 1,
        firstSerieId: 1,
        firstEventId: 1,
        firstStoryId: 1,
      ),
      name: 'Homem Aranha (Tobey maguire)',
      thumbnail: 'spiderman_thumbnail.jpg',
    )
  ];

  static CharacterOverviewEntity get characterOverviewEntity => list[0];
}
