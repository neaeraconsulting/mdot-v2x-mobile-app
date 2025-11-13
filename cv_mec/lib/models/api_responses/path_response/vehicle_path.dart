import 'package:cv_mec/models/api_responses/path_response/geometry.dart';
import 'package:cv_mec/models/api_responses/path_response/properties.dart';

class VehiclePath {
  final int id;
  final String name;
  final String type;
  final Properties properties;
  final Geometry geometry;
  final List<int> timestamps;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;

  VehiclePath({
    required this.id,
    required this.name,
    required this.type,
    required this.properties,
    required this.geometry,
    required this.timestamps,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory VehiclePath.fromJson(Map<String, dynamic> json) {
    return VehiclePath(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      properties: Properties.fromJson(json['properties']),
      geometry: Geometry.fromJson(json['geometry']),
      timestamps: List<int>.from(json['timestamps']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'properties': properties.toJson(),
        'geometry': geometry.toJson(),
        'timestamps': timestamps,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'createdBy': createdBy,
        'updatedBy': updatedBy,
      };
}