import 'character_preview_entity.dart';

class CharacterOverviewEntity extends CharacterPreviewEntity {
  final String description;

  CharacterOverviewEntity(this.description,
      {required super.id, required super.name, required super.thumbnail});
}
