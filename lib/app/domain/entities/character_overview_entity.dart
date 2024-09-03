import '../enum/character_by_content_type.dart';
import 'character_preview_entity.dart';

class CharacterOverviewEntity extends CharacterPreviewEntity {
  final String description;
  final CharacterFirstEncounter firstEncounter;
  CharacterOverviewEntity({
    required super.id,
    required super.name,
    required super.thumbnail,
    required this.description,
    required this.firstEncounter,
  });

  int idByType(CharacterByContentType type) {
    switch (type) {
      case CharacterByContentType.comics:
        return firstEncounter.firstComicId;
      case CharacterByContentType.series:
        return firstEncounter.firstSerieId;
      case CharacterByContentType.events:
        return firstEncounter.firstEventId;
      case CharacterByContentType.stories:
        return firstEncounter.firstStoryId;
    }
  }
}

class CharacterFirstEncounter {
  final int firstComicId;
  final int firstSerieId;
  final int firstEventId;
  final int firstStoryId;

  CharacterFirstEncounter(
      {required this.firstComicId,
      required this.firstSerieId,
      required this.firstEventId,
      required this.firstStoryId});
}
