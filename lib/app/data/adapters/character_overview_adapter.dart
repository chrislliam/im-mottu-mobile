import '../../domain/entities/character_overview_entity.dart';

class CharacterOverviewAdapter {
  static CharacterOverviewEntity fromJson(Map<String, dynamic> json) {
    int getFirstId(List<dynamic> items) {
      if (items.isNotEmpty) {
        final segments = (items.last['resourceURI'] as String).split('/');

        return int.tryParse(segments.last) ?? 0;
      } else {
        return 0;
      }
    }

    return CharacterOverviewEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      firstEncounter: CharacterFirstEncounter(
        firstComicId: getFirstId(json['comics']['items']),
        firstSerieId: getFirstId(json['series']['items']),
        firstEventId: getFirstId(json['events']['items']),
        firstStoryId: getFirstId(json['stories']['items']),
      ),
      thumbnail: json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
    );
  }
}
