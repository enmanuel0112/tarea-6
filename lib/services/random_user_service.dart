import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/random_person.dart';

class RandomUserService {
  RandomUserService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<RandomPerson> fetchPerson() async {
    final response = await _client
        .get(Uri.https('randomuser.me', '/api/', {'results': '1'}))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'El servicio respondió con error (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['results'] is! List) {
      throw const FormatException('La respuesta del servicio no es válida.');
    }
    final results = decoded['results'] as List<dynamic>;
    if (results.isEmpty || results.first is! Map<String, dynamic>) {
      throw const FormatException('No se encontró ninguna persona.');
    }
    return RandomPerson.fromJson(results.first as Map<String, dynamic>);
  }
}
