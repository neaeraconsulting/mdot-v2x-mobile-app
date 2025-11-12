import 'dart:convert';
import 'package:cv_mec/models/api_responses/secrets/s3_config.dart';

class SecretResponse {
  final String issScmsToken;
  final S3Config s3;
  final String mapboxAccessToken;
  final String noaaGeomagApiToken;

  SecretResponse({
    required this.issScmsToken,
    required this.s3,
    required this.mapboxAccessToken,
    required this.noaaGeomagApiToken,
  });

  factory SecretResponse.fromJson(Map<String, dynamic> json) {
    return SecretResponse(
      issScmsToken: json['iss_scms_token'] ?? '',
      s3: S3Config.fromJson(json['s3'] ?? {}),
      mapboxAccessToken: json['mapbox_access_token'] ?? '',
      noaaGeomagApiToken: json['noaa_geomag_api_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iss_scms_token': issScmsToken,
      's3': s3.toJson(),
      'mapbox_access_token': mapboxAccessToken,
      'noaa_geomag_api_token': noaaGeomagApiToken,
    };
  }

  static SecretResponse fromJsonString(String jsonString) {
    return SecretResponse.fromJson(jsonDecode(jsonString));
  }

  String toJsonString() => jsonEncode(toJson());
}

