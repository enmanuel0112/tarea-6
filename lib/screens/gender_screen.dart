import 'package:flutter/material.dart';

import '../models/gender_result.dart';
import '../services/gender_service.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _nameController = TextEditingController();
  final _genderService = GenderService();
  GenderResult? _result;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _consult() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _result = null;
        _errorMessage = 'Escribe un nombre para consultar.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await _genderService.predict(name);
      if (!mounted) return;
      setState(() => _result = result);
    } on Exception {
      if (!mounted) return;
      setState(
        () => _errorMessage = 'No se pudo realizar la consulta. Revisa tu conexión e inténtalo de nuevo.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gender = _result?.gender;
    final colors = Theme.of(context).colorScheme;
    final resultColor = switch (gender) {
      'male' => Colors.blue.shade50,
      'female' => Colors.pink.shade50,
      _ => colors.surfaceContainerHighest,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Predecir género')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _consult(),
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Escribe un nombre',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _consult,
            child: const Text('Consultar'),
          ),
          if (_isLoading) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_errorMessage case final message?) ...[
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: colors.error)),
          ],
          if (_result case final result?) ...[
            const SizedBox(height: 24),
            Card(
              color: resultColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${result.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Género: ${_genderLabel(result.gender)}'),
                    const SizedBox(height: 8),
                    Text(
                      'Probabilidad: ${result.probability == null ? 'No disponible' : '${(result.probability! * 100).toStringAsFixed(0)}%'}',
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

  String _genderLabel(String? gender) => switch (gender) {
    'male' => 'Masculino',
    'female' => 'Femenino',
    _ => 'No determinado',
  };
}
