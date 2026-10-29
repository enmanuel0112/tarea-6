class Weather {
  const Weather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
    required this.dailyWeatherCode,
  });

  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final int precipitationProbabilityMax;
  final int dailyWeatherCode;

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final daily = json['daily'];
    if (current is! Map<String, dynamic> || daily is! Map<String, dynamic>) {
      throw const FormatException('La respuesta del clima está incompleta.');
    }
    final requiredDaily = [
      daily['temperature_2m_max'],
      daily['temperature_2m_min'],
      daily['precipitation_probability_max'],
      daily['weather_code'],
    ];
    if (requiredDaily.any((value) => value is! List || value.isEmpty)) {
      throw const FormatException('No hay datos diarios disponibles.');
    }

    double number(Map<String, dynamic> source, String key) {
      final value = source[key];
      if (value is! num) throw FormatException('Falta el dato $key.');
      return value.toDouble();
    }

    int integer(Map<String, dynamic> source, String key) {
      final value = source[key];
      if (value is! num) throw FormatException('Falta el dato $key.');
      return value.toInt();
    }

    double dailyNumber(String key) {
      final value = (daily[key] as List).first;
      if (value is! num) throw FormatException('Falta el dato $key.');
      return value.toDouble();
    }

    return Weather(
      temperature: number(current, 'temperature_2m'),
      apparentTemperature: number(current, 'apparent_temperature'),
      humidity: integer(current, 'relative_humidity_2m'),
      windSpeed: number(current, 'wind_speed_10m'),
      precipitation: number(current, 'precipitation'),
      weatherCode: integer(current, 'weather_code'),
      temperatureMax: dailyNumber('temperature_2m_max'),
      temperatureMin: dailyNumber('temperature_2m_min'),
      precipitationProbabilityMax: dailyNumber('precipitation_probability_max')
          .toInt(),
      dailyWeatherCode: dailyNumber('weather_code').toInt(),
    );
  }

  static String descriptionForCode(int code) => switch (code) {
    0 => 'Despejado',
    1 || 2 => 'Parcialmente nublado',
    3 => 'Nublado',
    45 || 48 => 'Neblina',
    >= 51 && <= 67 => 'Lluvia',
    >= 80 && <= 82 => 'Chubascos',
    >= 95 && <= 99 => 'Tormenta',
    _ => 'Condición variable',
  };

  static WeatherIcon iconForCode(int code) => switch (code) {
    0 => WeatherIcon.sun,
    1 || 2 || 3 || 45 || 48 => WeatherIcon.cloud,
    >= 95 && <= 99 => WeatherIcon.storm,
    >= 51 && <= 67 || >= 80 && <= 82 => WeatherIcon.rain,
    _ => WeatherIcon.cloud,
  };
}

enum WeatherIcon { sun, cloud, rain, storm }
