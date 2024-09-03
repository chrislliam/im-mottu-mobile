import '../../domain/entities/character_preview_entity.dart';

class CharacterPreviewAdapter {
  static CharacterPreviewEntity fromJson(dynamic json) {
    return CharacterPreviewEntity(
      id: json['id'],
      thumbnail:
          json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
      name: json['name'],
    );
  }

  static List<CharacterPreviewEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return CharacterPreviewAdapter.fromJson(json);
    }).toList();
  }
}
