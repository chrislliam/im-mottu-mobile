import 'character_preview_entity.dart';

class CharacterOverviewEntity extends CharacterPreviewEntity {
  final String description;

  CharacterOverviewEntity(
      {required super.id, required super.name, required super.thumbnail,required this.description,});
}
