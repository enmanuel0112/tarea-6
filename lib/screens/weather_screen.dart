import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _service = WeatherService();
  Weather? _weather;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final weather = await _service.fetchWeather();
      if (!mounted) return;
      setState(() => _weather = weather);
    } on Exception {
      if (!mounted) return;
      setState(() {
        _weather = null;
        _errorMessage = 'No se pudo obtener el clima. Revisa tu conexión e inténtalo de nuevo.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = _weather;
    return Scaffold(
      appBar: AppBar(title: const Text('Clima RD')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Santo Domingo, República Dominicana',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (_isLoading) ...[
            const SizedBox(height: 32),
            const Center(child: CircularProgressIndicator()),
          ] else if (_errorMessage case final message?) ...[
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ] else if (weather != null) ...[
            const SizedBox(height: 20),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(_weatherIcon(weather.weatherCode), size: 64),
                    const SizedBox(height: 8),
                    Text(
                      Weather.descriptionForCode(weather.weatherCode),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)} °C',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _WeatherRow(
                    'Sensación térmica',
                    '${weather.apparentTemperature.toStringAsFixed(1)} °C',
                  ),
                  _WeatherRow('Humedad', '${weather.humidity}%'),
                  _WeatherRow(
                    'Velocidad del viento',
                    '${weather.windSpeed.toStringAsFixed(1)} km/h',
                  ),
                  _WeatherRow(
                    'Precipitación actual',
                    '${weather.precipitation.toStringAsFixed(1)} mm',
                  ),
                  _WeatherRow(
                    'Temperatura máxima de hoy',
                    '${weather.temperatureMax.toStringAsFixed(1)} °C',
                  ),
                  _WeatherRow(
                    'Temperatura mínima de hoy',
                    '${weather.temperatureMin.toStringAsFixed(1)} °C',
                  ),
                  _WeatherRow(
                    'Probabilidad máxima de lluvia',
                    '${weather.precipitationProbabilityMax}%',
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _isLoading ? null : _loadWeather,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar clima'),
          ),
        ],
      ),
    );
  }

  IconData _weatherIcon(int code) => switch (Weather.iconForCode(code)) {
    WeatherIcon.sun => Icons.wb_sunny_outlined,
    WeatherIcon.cloud => Icons.cloud_outlined,
    WeatherIcon.rain => Icons.umbrella_outlined,
    WeatherIcon.storm => Icons.thunderstorm_outlined,
  };
}

class _WeatherRow extends StatelessWidget {
  const _WeatherRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(label), trailing: Text(value));
  }
}
