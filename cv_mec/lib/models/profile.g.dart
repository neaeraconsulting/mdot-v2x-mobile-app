// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile()
  ..name = json['name'] as String
  ..keyCloakEndpoint = json['keyCloakEndpoint'] as String
  ..cimmsBroker = json['cimmsBroker'] as String
  ..realm = json['realm'] as String
  ..client = json['client'] as String
  ..clientSecret = json['clientSecret'] as String;

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'name': instance.name,
      'keyCloakEndpoint': instance.keyCloakEndpoint,
      'cimmsBroker': instance.cimmsBroker,
      'realm': instance.realm,
      'client': instance.client,
      'clientSecret': instance.clientSecret,
    };
