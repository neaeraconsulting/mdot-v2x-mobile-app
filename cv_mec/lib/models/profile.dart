// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  late String name;
  late String keyCloakEndpoint;
  late String cimmsBroker;
  late String realm;
  late String client;
  late String clientSecret;

  Profile() {
    name = "";
    keyCloakEndpoint = "";
    cimmsBroker = "";
    realm = "";
    client = "";
    clientSecret = "";
  }

  Profile.detailed(this.name, this.keyCloakEndpoint, this.cimmsBroker, this.realm, this.client, this.clientSecret);

  String concatenate() {
    return "$name,$keyCloakEndpoint,$cimmsBroker,$realm,$client,$clientSecret";
  }

  Profile.deconcatenate(String concatenated) {
    List<String> split = concatenated.split(",");
    if (split.length != 1) {
      name = split[0];
      keyCloakEndpoint = split[1];
      cimmsBroker = split[2];
      realm = split[3];
      client = split[4];
      clientSecret = split[5];
    }
  }

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
