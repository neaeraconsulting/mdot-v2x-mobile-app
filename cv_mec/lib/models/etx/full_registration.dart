//ignore: depend_on_referenced_packages
import 'package:cv_mec/models/etx/registration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'full_registration.g.dart';

@JsonSerializable()
class FullRegistration {
  final Certificates certificates;
  final String deviceID;
  final String clientSubtype;
  final String clientType;
  final String vendorID;

  FullRegistration({
    required this.certificates,
    required this.deviceID,
    required this.clientSubtype,
    required this.clientType,
    required this.vendorID,
  });

  factory FullRegistration.fromJson(Map<String, dynamic> json) =>
      _$FullRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$FullRegistrationToJson(this);
}
