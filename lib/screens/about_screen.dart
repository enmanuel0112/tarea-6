import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _description =
      'Estudiante de desarrollo de software interesado en desarrollo móvil, aplicaciones multiplataforma y nuevas tecnologías.';

  List<_Contact> get _contacts => [
    _Contact(
      'Correo electrónico',
      AppConstants.email,
      Uri.tryParse('mailto:${AppConstants.email}'),
    ),
    _Contact(
      'WhatsApp',
      AppConstants.whatsapp,
      _httpsUri('https://wa.me/', AppConstants.whatsapp),
    ),
    _Contact(
      'Telegram',
      AppConstants.telegram,
      _httpsUri('https://t.me/', AppConstants.telegram),
    ),
    _Contact(
      'GitHub',
      AppConstants.github,
      _httpsUri('https://github.com/', AppConstants.github),
    ),
    _Contact(
      'LinkedIn',
      AppConstants.linkedIn,
      _httpsUri('https://linkedin.com/in/', AppConstants.linkedIn),
    ),
  ];

  static Uri? _httpsUri(String prefix, String value) =>
      Uri.tryParse('$prefix$value');

  @override
  Widget build(BuildContext context) {
    final availableContacts = _contacts
        .where((contact) => !contact.value.startsWith('TODO_'))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 68,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondaryContainer,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/cesar.jpg',
                        width: 136,
                        height: 136,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person_outline,
                          size: 72,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text('Matrícula: ${AppConstants.studentId}'),
                  const SizedBox(height: 16),
                  Text(_description, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          if (availableContacts.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Contacto', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...availableContacts.map(
              (contact) => ListTile(
                leading: const Icon(Icons.link),
                title: Text(contact.label),
                subtitle: Text(contact.value),
                onTap: contact.uri == null || !contact.uri!.hasScheme
                    ? null
                    : () => _openContact(context, contact.uri!),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openContact(BuildContext context, Uri uri) async {
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
          context.mounted) {
        _showError(context);
      }
    } on Exception {
      if (context.mounted) _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace.')),
    );
  }
}

class _Contact {
  const _Contact(this.label, this.value, this.uri);

  final String label;
  final String value;
  final Uri? uri;
}
