// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'declination_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeclinationData _$DeclinationDataFromJson(Map<String, dynamic> json) =>
    DeclinationData(
      result: (json['result'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
      model: json['model'] as String,
      units: Units.fromJson(json['units'] as Map<String, dynamic>),
      version: json['version'] as String,
    );

Map<String, dynamic> _$DeclinationDataToJson(DeclinationData instance) =>
    <String, dynamic>{
      'result': instance.result,
      'model': instance.model,
      'units': instance.units,
      'version': instance.version,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      date: (json['date'] as num).toDouble(),
      elevation: (json['elevation'] as num).toInt(),
      declination: (json['declination'] as num).toDouble(),
      latitude: (json['latitude'] as num).toInt(),
      declinationSv: (json['declnation_sv'] as num?)?.toDouble(),
      declinationUncertainty:
          (json['declination_uncertainty'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'date': instance.date,
      'elevation': instance.elevation,
      'declination': instance.declination,
      'latitude': instance.latitude,
      'declnation_sv': instance.declinationSv,
      'declination_uncertainty': instance.declinationUncertainty,
      'longitude': instance.longitude,
    };

Units _$UnitsFromJson(Map<String, dynamic> json) => Units(
      elevation: json['elevation'] as String,
      declination: json['declination'] as String,
      declinationSv: json['declination_sv'] as String,
      latitude: json['latitude'] as String,
      declinationUncertainty: json['declination_uncertainty'] as String,
      longitude: json['longitude'] as String,
    );

Map<String, dynamic> _$UnitsToJson(Units instance) => <String, dynamic>{
      'elevation': instance.elevation,
      'declination': instance.declination,
      'declination_sv': instance.declinationSv,
      'latitude': instance.latitude,
      'declination_uncertainty': instance.declinationUncertainty,
      'longitude': instance.longitude,
    };
