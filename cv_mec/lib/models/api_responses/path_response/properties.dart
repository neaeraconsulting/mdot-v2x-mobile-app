class Properties {
  final String name;

  Properties({required this.name});

  factory Properties.fromJson(Map<String, dynamic> json) =>
      Properties(name: json['name']);

  Map<String, dynamic> toJson() => {'name': name};
}