import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wordpress_post.dart';

const wordpressApiBase = 'https://wordpress.org/news/wp-json/wp/v2/posts';

class WordpressService {
  WordpressService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<WordpressPost>> fetchLatestPosts() async {
    final baseUri = Uri.parse(wordpressApiBase);
    final uri = baseUri.replace(
      queryParameters: {
        'per_page': '3',
        '_fields': 'id,date,link,title,excerpt',
      },
    );
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
    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'La respuesta contiene datos inválidos.',
            );
          }
          return WordpressPost.fromJson(item);
        })
        .take(3)
        .toList();
  }
}
