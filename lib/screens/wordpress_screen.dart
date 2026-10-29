import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wordpress_post.dart';
import '../services/wordpress_service.dart';

class WordpressScreen extends StatefulWidget {
  const WordpressScreen({super.key});

  @override
  State<WordpressScreen> createState() => _WordpressScreenState();
}

class _WordpressScreenState extends State<WordpressScreen> {
  final _service = WordpressService();
  List<WordpressPost> _posts = [];
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final posts = await _service.fetchLatestPosts();
      if (!mounted) return;
      setState(() => _posts = posts);
    } on Exception {
      if (!mounted) return;
      setState(() {
        _posts = [];
        _errorMessage = 'No se pudieron cargar las noticias. Revisa tu conexión e inténtalo de nuevo.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _visit(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      _showLinkError();
      return;
    }
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
          mounted) {
        _showLinkError();
      }
    } on Exception {
      if (mounted) _showLinkError();
    }
  }

  void _showLinkError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir la noticia.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wordpress,
                  size: 42,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Últimas noticias',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          if (_errorMessage case final message?)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(message, textAlign: TextAlign.center),
                  TextButton(
                    onPressed: _loadPosts,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          if (!_isLoading && _errorMessage == null && _posts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No hay noticias disponibles.'),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(post.excerpt),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('dd/MM/yyyy').format(post.date.toLocal()),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _visit(post.link),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Visitar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
