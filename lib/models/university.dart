class University {
  const University({
    required this.name,
    required this.domain,
    required this.webPage,
  });

  final String name;
  final String domain;
  final String webPage;

  factory University.fromJson(Map<String, dynamic> json) {
    final domains = json['domains'];
    final webPages = json['web_pages'];
    if (domains is! List || webPages is! List) {
      throw const FormatException(
        'Los datos de la universidad no son válidos.',
      );
    }
    return University(
      name: json['name'] as String? ?? 'Nombre no disponible',
      domain: domains.isEmpty ? 'Dominio no disponible' : '${domains.first}',
      webPage: webPages.isEmpty ? '' : '${webPages.first}',
    );
  }
}
