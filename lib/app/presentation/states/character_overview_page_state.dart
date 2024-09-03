import '../../domain/entities/character_overview_entity.dart';

sealed class CharacterOverviewPageState {}

class CharacterOverviewPageLoading extends CharacterOverviewPageState {}

class CharacterOverviewPageSuccess extends CharacterOverviewPageState {
  final CharacterOverviewEntity character;

  CharacterOverviewPageSuccess(this.character);
}

class CharacterOverviewPageError extends CharacterOverviewPageState {
  final String message;

  CharacterOverviewPageError(this.message);
}
