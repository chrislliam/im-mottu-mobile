import '../../domain/entities/character_overview_entity.dart';

class CharacterOverviewAdapter {
  static CharacterOverviewEntity fromJson(Map<String, dynamic> json) {
    return CharacterOverviewEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnail:
          json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
    );
  }
}
