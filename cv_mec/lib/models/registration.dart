//ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'registration.g.dart';

@JsonSerializable()
class Registration {
  final Certificates certificates;
  final String deviceID;

  Registration({
    required this.certificates,
    required this.deviceID,
  });

  factory Registration.fromJson(Map<String, dynamic> json) => _$RegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationToJson(this);
}


@JsonSerializable()
class Certificates {
  final String ca;
  final String cert;
  final String key;

  

  Certificates({
    required this.ca,
    required this.cert,
    required this.key,
  });

  factory Certificates.fromJson(Map<String, dynamic> json) => _$CertificatesFromJson(json);

  Map<String, dynamic> toJson() => _$CertificatesToJson(this);
}