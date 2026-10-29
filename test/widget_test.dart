import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarea_6_couteau/main.dart';

void main() {
  testWidgets('Home muestra el título y las siete herramientas', (
    tester,
  ) async {
    await tester.pumpWidget(const MultiToolApp());

    expect(find.text('MultiTool ITLA'), findsOneWidget);
    for (final title in [
      'Género',
      'Persona aleatoria',
      'Universidades',
      'Clima RD',
      'Pokémon',
      'Noticias',
      'Acerca de',
    ]) {
      await tester.scrollUntilVisible(
        find.text(title),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(title), findsOneWidget);
    }
  });
}
