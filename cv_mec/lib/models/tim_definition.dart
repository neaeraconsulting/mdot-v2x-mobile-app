

import 'package:cv_mec/models/text_overlay.dart';

class TimDefinition {
  late String name;
  late String type;
  late String source;
  late List<String> codes;
  late String graphic;
  List<TextOverlay> overlays = [];

  TimDefinition({
    required this.name,
    required this.source,
    required this.type,
    required this.codes,
    required this.graphic,
    required this.overlays,
  });

  factory TimDefinition.fromJson(Map<String, dynamic> json) {
    return TimDefinition(
      name: json['name'] ?? '',
      source: json['source'] ?? '',
      type: json['type'] ?? '',
      codes: (json['codes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      graphic: json['graphic'] ?? '',
      overlays: (json['overlays'] as List<dynamic>?)
              ?.map((e) => TextOverlay.fromJson(e))
              .toList() ??
          [],
    );
    
  }
  
  // Convert back to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'source': source,
    'type': type,
    'codes': codes,
    'graphic': graphic,
    'overlays': overlays.map((e) => e.toJson()).toList(),
  };
}