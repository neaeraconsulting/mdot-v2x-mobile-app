// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullRegistration _$FullRegistrationFromJson(Map<String, dynamic> json) => FullRegistration(
      certificates:
          Certificates.fromJson(json['Certificate'] as Map<String, dynamic>),
      deviceID: json['DeviceID'] as String,
      clientSubtype: json['ClientSubtype'] as String,
      clientType: json['ClientType'] as String,
      vendorID: json['VendorID'] as String,

    );

Map<String, dynamic> _$FullRegistrationToJson(FullRegistration instance) =>
    <String, dynamic>{
      'Certificate': instance.certificates,
      'DeviceID': instance.deviceID,
    };
