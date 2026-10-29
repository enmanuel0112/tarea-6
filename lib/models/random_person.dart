class RandomPerson {
  const RandomPerson({
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.birthDate,
    required this.age,
  });

  final String firstName;
  final String lastName;
  final String photoUrl;
  final DateTime birthDate;
  final int age;

  factory RandomPerson.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final picture = json['picture'];
    final dob = json['dob'];
    if (name is! Map<String, dynamic> ||
        picture is! Map<String, dynamic> ||
        dob is! Map<String, dynamic>) {
      throw const FormatException('Los datos de la persona están incompletos.');
    }

    final date = DateTime.tryParse(dob['date'] as String? ?? '');
    final age = dob['age'];
    if (date == null || age is! num) {
      throw const FormatException('La fecha de nacimiento no es válida.');
    }

    return RandomPerson(
      firstName: name['first'] as String? ?? '',
      lastName: name['last'] as String? ?? '',
      photoUrl: picture['large'] as String? ?? '',
      birthDate: date,
      age: age.toInt(),
    );
  }
}
