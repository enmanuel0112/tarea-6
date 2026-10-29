import 'package:html/parser.dart' as html_parser;

class WordpressPost {
  const WordpressPost({
    required this.id,
    required this.date,
    required this.link,
    required this.title,
    required this.excerpt,
  });

  final int id;
  final DateTime date;
  final String link;
  final String title;
  final String excerpt;

  factory WordpressPost.fromJson(Map<String, dynamic> json) {
    final titleData = json['title'];
    final excerptData = json['excerpt'];
    final dateValue = json['date'];
    final linkValue = json['link'];
    final idValue = json['id'];
    if (titleData is! Map<String, dynamic> ||
        excerptData is! Map<String, dynamic> ||
        dateValue is! String ||
        linkValue is! String ||
        idValue is! int ||
        titleData['rendered'] is! String ||
        excerptData['rendered'] is! String) {
      throw const FormatException('La noticia contiene datos inválidos.');
    }

    final parsedDate = DateTime.tryParse(dateValue);
    if (parsedDate == null) {
      throw const FormatException('La fecha de la noticia no es válida.');
    }
    return WordpressPost(
      id: idValue,
      date: parsedDate,
      link: linkValue,
      title: _cleanHtml(titleData['rendered'] as String),
      excerpt: _cleanHtml(excerptData['rendered'] as String),
    );
  }

  static String _cleanHtml(String value) =>
      html_parser.parse(value).documentElement?.text.trim() ?? '';
}
