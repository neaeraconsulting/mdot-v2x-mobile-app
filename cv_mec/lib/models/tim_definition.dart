class TimDefinition {
  final String name;
  final String type;
  final List<int> codes;
  final String graphic;

  TimDefinition({
    required this.name,
    required this.type,
    required this.codes,
    required this.graphic,
  });

  factory TimDefinition.fromJson(Map<String, dynamic> json) {
    return TimDefinition(
      name: json['name'],
      type: json['type'],
      codes: List<int>.from(json['codes']),
      graphic: json['graphic'],
    );
  }
}