import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/gender_result.dart';

class GenderService {
  GenderService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<GenderResult> predict(String name) async {
    final uri = Uri.https('api.genderize.io', '/', {'name': name});
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'El servicio respondió con error (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del servicio no es válida.');
    }
    return GenderResult.fromJson(decoded);
  }
}
