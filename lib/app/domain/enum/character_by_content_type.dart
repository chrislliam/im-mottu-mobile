enum CharacterByContentType {
  comics(label: 'Quadrinhos'),
  series(label: 'Séries'),
  stories(label: 'Histórias'),
  events(label: 'Eventos'),
  ;

  final String label;

  const CharacterByContentType({required this.label});
}
