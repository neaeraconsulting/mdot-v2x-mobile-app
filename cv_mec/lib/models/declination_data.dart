// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'declination_data.g.dart';

@JsonSerializable()
class DeclinationData {
  final List<Result> result;
  final String model;
  final Units units;
  final String version;

  DeclinationData({
    required this.result,
    required this.model,
    required this.units,
    required this.version,
  });

  factory DeclinationData.fromJson(Map<String, dynamic> json) => _$DeclinationDataFromJson(json);

  Map<String, dynamic> toJson() => _$DeclinationDataToJson(this);
}

@JsonSerializable()
class Result {
  final double date;
  final int elevation;
  final double declination;
  final int latitude;
  @JsonKey(name: 'declnation_sv')
  final double? declinationSv;
  @JsonKey(name: 'declination_uncertainty')
  final double declinationUncertainty;
  final double longitude;

  Result({
    required this.date,
    required this.elevation,
    required this.declination,
    required this.latitude,
    required this.declinationSv,
    required this.declinationUncertainty,
    required this.longitude,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Units {
  final String elevation;
  final String declination;
  @JsonKey(name: 'declination_sv')
  final String declinationSv;
  final String latitude;
  @JsonKey(name: 'declination_uncertainty')
  final String declinationUncertainty;
  final String longitude;

  Units({
    required this.elevation,
    required this.declination,
    required this.declinationSv,
    required this.latitude,
    required this.declinationUncertainty,
    required this.longitude,
  });

  factory Units.fromJson(Map<String, dynamic> json) => _$UnitsFromJson(json);

  Map<String, dynamic> toJson() => _$UnitsToJson(this);
}
