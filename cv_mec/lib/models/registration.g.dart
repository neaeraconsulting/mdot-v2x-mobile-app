// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Registration _$RegistrationFromJson(
        Map<String, dynamic> json) =>
    Registration(
      certificates: Certificates.fromJson(json['Certificate'] as Map<String, dynamic>),
      deviceID: json['DeviceID'] as String,
    );

Map<String, dynamic> _$RegistrationToJson(
        Registration instance) =>
    <String, dynamic>{
      'Certificate': instance.certificates,
      'DeviceID': instance.deviceID,
    };

Certificates _$CertificatesFromJson(Map<String, dynamic> json) =>
    Certificates(
      ca: json['ca.pem'] as String,
      cert: json['cert.pem'] as String,
      key: json['key.pem'] as String,
    );

Map<String, dynamic> _$CertificatesToJson(Certificates instance) =>
    <String, dynamic>{
      'ca.pem': instance.ca,
      'cert.pem': instance.cert,
      'key.pem': instance.key,
    };