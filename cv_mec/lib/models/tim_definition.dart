

import 'package:cv_mec/models/text_overlay.dart';

class TimDefinition {
  late String name;
  late String type;
  late List<String> codes;
  late String graphic;
  List<TextOverlay> overlays = [];

  TimDefinition({
    required this.name,
    required this.type,
    required this.codes,
    required this.graphic,
    required this.overlays,
  });

  factory TimDefinition.fromJson(Map<String, dynamic> json) {
    return TimDefinition(
      name: json['name'] ?? '',
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
    'type': type,
    'codes': codes,
    'graphic': graphic,
    'overlays': overlays.map((e) => e.toJson()).toList(),
  };
}

  // factory TimDefinition.fromJson(Map<String, dynamic> json) {
  //   TimDefinition tim = TimDefinition();
  //   tim.name = json['name'];
  //   tim.type = json['type'];
  //   tim.codes = List<String>.from(json['codes']);
  //   tim.graphic = json['graphic'];
  //   tim.overlays = [];
  // }