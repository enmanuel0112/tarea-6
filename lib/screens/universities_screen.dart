import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/university.dart';
import '../services/university_service.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final _countryController = TextEditingController();
  final _service = UniversityService();
  List<University> _universities = [];
  String? _errorMessage;
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final country = _countryController.text.trim();
    if (country.isEmpty) {
      setState(() {
        _hasSearched = false;
        _universities = [];
        _errorMessage = 'Escribe el país en inglés para buscar.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
      _universities = [];
    });

    try {
      final universities = await _service.search(country);
      if (!mounted) return;
      setState(() => _universities = universities);
    } on Exception {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo completar la búsqueda. Revisa tu conexión e inténtalo de nuevo.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _visit(String page) async {
    final uri = Uri.tryParse(page);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La página web no es válida.')),
      );
      return;
    }
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir la página web.')),
        );
      }
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la página web.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _countryController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: const InputDecoration(
                    labelText: 'País en inglés',
                    hintText: 'Ejemplo: Dominican Republic',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.public),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _search,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          if (_errorMessage case final message?)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          if (!_isLoading &&
              _hasSearched &&
              _errorMessage == null &&
              _universities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No se encontraron universidades para ese país.'),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _universities.length,
              itemBuilder: (context, index) {
                final university = _universities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Dominio: ${university.domain}'),
                        Text(
                          'Página web: ${university.webPage.isEmpty ? 'No disponible' : university.webPage}',
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: university.webPage.isEmpty
                                ? null
                                : () => _visit(university.webPage),
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
