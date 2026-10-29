import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/random_person.dart';
import '../services/random_user_service.dart';

class RandomPersonScreen extends StatefulWidget {
  const RandomPersonScreen({super.key});

  @override
  State<RandomPersonScreen> createState() => _RandomPersonScreenState();
}

class _RandomPersonScreenState extends State<RandomPersonScreen> {
  final _service = RandomUserService();
  RandomPerson? _person;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPerson();
  }

  Future<void> _loadPerson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final person = await _service.fetchPerson();
      if (!mounted) return;
      setState(() => _person = person);
    } on Exception {
      if (!mounted) return;
      setState(() {
        _person = null;
        _errorMessage = 'No se pudo obtener una persona. Revisa tu conexión e inténtalo de nuevo.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final person = _person;
    return Scaffold(
      appBar: AppBar(title: const Text('Persona aleatoria')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage case final message?)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            )
          else if (person != null) ...[
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .secondaryContainer,
                backgroundImage: person.photoUrl.isEmpty
                    ? null
                    : NetworkImage(person.photoUrl),
                child: person.photoUrl.isEmpty
                    ? const Icon(Icons.person, size: 96)
                    : null,
                onBackgroundImageError: (_, _) {},
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _PersonDetail(label: 'Nombre', value: person.firstName),
                    _PersonDetail(label: 'Apellido', value: person.lastName),
                    _PersonDetail(
                      label: 'Fecha de nacimiento',
                      value: DateFormat('dd/MM/yyyy').format(person.birthDate),
                    ),
                    _PersonDetail(label: 'Edad', value: '${person.age} años'),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isLoading ? null : _loadPerson,
            icon: const Icon(Icons.refresh),
            label: const Text('Generar otra persona'),
          ),
        ],
      ),
    );
  }
}

class _PersonDetail extends StatelessWidget {
  const _PersonDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 12),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
