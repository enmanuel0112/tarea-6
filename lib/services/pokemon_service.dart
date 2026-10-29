import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonNotFoundException implements Exception {}

class PokemonService {
  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Pokemon> fetchPokemon(String name) async {
    final normalizedName = name.trim().toLowerCase();
    final uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$normalizedName');
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 404) throw PokemonNotFoundException();
    if (response.statusCode != 200) {
      throw Exception(
        'El servicio respondió con error (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del servicio no es válida.');
    }
    return Pokemon.fromJson(decoded);
  }
}
