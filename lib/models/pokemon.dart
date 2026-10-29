class Pokemon {
  const Pokemon({
    required this.name,
    required this.baseExperience,
    required this.abilities,
    required this.imageUrl,
    required this.soundUrl,
  });

  final String name;
  final int baseExperience;
  final List<String> abilities;
  final String? imageUrl;
  final String? soundUrl;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'];
    final cries = json['cries'];
    final abilitiesJson = json['abilities'];
    if (sprites is! Map<String, dynamic> ||
        cries is! Map<String, dynamic> ||
        abilitiesJson is! List) {
      throw const FormatException('Los datos del Pokémon están incompletos.');
    }

    final other = sprites['other'];
    String? artwork;
    if (other is Map<String, dynamic>) {
      final official = other['official-artwork'];
      if (official is Map<String, dynamic>) {
        artwork = official['front_default'] as String?;
      }
    }
    final fallbackImage = sprites['front_default'] as String?;

    final parsedAbilities = <String>[];
    for (final entry in abilitiesJson) {
      if (entry is Map<String, dynamic> &&
          entry['ability'] is Map<String, dynamic>) {
        final ability = entry['ability'] as Map<String, dynamic>;
        if (ability['name'] is String) {
          parsedAbilities.add(ability['name'] as String);
        }
      }
    }

    final name = json['name'];
    final experience = json['base_experience'];
    if (name is! String || experience is! num) {
      throw const FormatException(
        'Los datos principales del Pokémon no son válidos.',
      );
    }

    return Pokemon(
      name: name,
      baseExperience: experience.toInt(),
      abilities: parsedAbilities,
      imageUrl: artwork ?? fallbackImage,
      soundUrl: cries['latest'] as String?,
    );
  }
}
