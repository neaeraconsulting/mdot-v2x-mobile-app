import 'dart:convert';
import 'package:cv_mec/models/api_responses/path_response/vehicle_path.dart';

class PathResponse {
  final List<VehiclePath> paths;

  PathResponse({required this.paths});

  factory PathResponse.fromJson(Map<String, dynamic> json) {
    return PathResponse(
      paths: (json['paths'] as List<dynamic>)
          .map((e) => VehiclePath.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'paths': paths.map((e) => e.toJson()).toList(),
      };

  static PathResponse fromJsonString(String jsonString) =>
      PathResponse.fromJson(json.decode(jsonString));

  String toJsonString() => json.encode(toJson());
}