import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/university.dart';

class UniversityService {
  UniversityService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<University>> search(String country) async {
    final uri = Uri.https('adamix.net', '/proxy.php', {'country': country});
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'El servicio respondió con error (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('La respuesta del servicio no es una lista.');
    }

    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('La respuesta contiene datos inválidos.');
      }
      return University.fromJson(item);
    }).toList();
  }
}
