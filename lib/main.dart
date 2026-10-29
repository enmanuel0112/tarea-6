import 'package:flutter/material.dart';

import 'screens/gender_screen.dart';
import 'screens/about_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/random_person_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/wordpress_screen.dart';

void main() {
  runApp(const MultiToolApp());
}

class MultiToolApp extends StatelessWidget {
  const MultiToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiTool ITLA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<(String, IconData)> tools = [
    ('Género', Icons.person_search_outlined),
    ('Persona aleatoria', Icons.face_retouching_natural_outlined),
    ('Universidades', Icons.school_outlined),
    ('Clima RD', Icons.cloud_outlined),
    ('Pokémon', Icons.catching_pokemon_outlined),
    ('Noticias', Icons.newspaper_outlined),
    ('Acerca de', Icons.info_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiTool ITLA'), centerTitle: true),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/toolbox.png',
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer,
                          child: Icon(
                            Icons.home_repair_service_outlined,
                            size: 72,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tus herramientas en un solo lugar',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.18,
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final (title, icon) = tools[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap:
                          title == 'Género' ||
                              title == 'Persona aleatoria' ||
                              title == 'Universidades' ||
                              title == 'Clima RD' ||
                              title == 'Pokémon' ||
                              title == 'Noticias' ||
                              title == 'Acerca de'
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => switch (title) {
                                  'Género' => const GenderScreen(),
                                  'Persona aleatoria' =>
                                    const RandomPersonScreen(),
                                  'Clima RD' => const WeatherScreen(),
                                  'Pokémon' => const PokemonScreen(),
                                  'Noticias' => const WordpressScreen(),
                                  'Acerca de' => const AboutScreen(),
                                  _ => const UniversitiesScreen(),
                                },
                              ),
                            )
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 38,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
