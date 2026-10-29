import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _nameController = TextEditingController();
  final _service = PokemonService();
  final _audioPlayer = AudioPlayer();
  Pokemon? _pokemon;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isPlaying = false;
  bool _imageFailed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final name = _nameController.text.trim().toLowerCase();
    if (name.isEmpty) {
      setState(() {
        _pokemon = null;
        _errorMessage = 'Escribe el nombre de un Pokémon.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _pokemon = null;
      _errorMessage = null;
      _imageFailed = false;
    });
    try {
      final pokemon = await _service.fetchPokemon(name);
      if (!mounted) return;
      setState(() => _pokemon = pokemon);
    } on PokemonNotFoundException {
      if (!mounted) return;
      setState(() => _errorMessage = 'Pokémon no encontrado');
    } on Exception {
      if (!mounted) return;
      setState(
        () => _errorMessage = 'No se pudo realizar la búsqueda. Revisa tu conexión e inténtalo de nuevo.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _playSound() async {
    final url = _pokemon?.soundUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este Pokémon no tiene sonido disponible.'),
        ),
      );
      return;
    }
    setState(() => _isPlaying = true);
    try {
      await _audioPlayer.play(UrlSource(url));
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo reproducir el sonido.')),
      );
    } finally {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = _pokemon;
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: const InputDecoration(
              labelText: 'Nombre del Pokémon',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.catching_pokemon_outlined),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _isLoading ? null : _search,
            icon: const Icon(Icons.search),
            label: const Text('Buscar'),
          ),
          if (_isLoading) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_errorMessage case final message?) ...[
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (pokemon != null) ...[
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (pokemon.imageUrl != null && !_imageFailed)
                      Image.network(
                        pokemon.imageUrl!,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          _imageFailed = true;
                          return const SizedBox(
                            height: 200,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 72,
                            ),
                          );
                        },
                      )
                    else
                      const SizedBox(
                        height: 200,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 72,
                        ),
                      ),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Experiencia base: ${pokemon.baseExperience}'),
                    const SizedBox(height: 12),
                    Text(
                      'Habilidades',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      pokemon.abilities.isEmpty
                          ? 'No disponibles'
                          : pokemon.abilities.join(', '),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _isPlaying ? null : _playSound,
                      icon: const Icon(Icons.volume_up_outlined),
                      label: Text(
                        _isPlaying ? 'Reproduciendo…' : 'Reproducir sonido',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
