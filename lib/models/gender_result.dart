class GenderResult {
  const GenderResult({
    required this.name,
    required this.gender,
    required this.probability,
  });

  final String name;
  final String? gender;
  final double? probability;

  factory GenderResult.fromJson(Map<String, dynamic> json) {
    return GenderResult(
      name: json['name'] as String? ?? '',
      gender: json['gender'] as String?,
      probability: (json['probability'] as num?)?.toDouble(),
    );
  }
}
