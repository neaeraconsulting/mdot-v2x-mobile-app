library iss_scms;

import 'package:iss_scms/models/expiration_information.dart';
import 'package:iss_scms/models/signing_api_state.dart';
import 'package:iss_scms/models/token_type.dart';
import 'package:iss_scms/models/validate_status.dart';

import 'iss_scms_platform_interface.dart';

class IssScms {
  
  IssScms(){
    init();
  }
  
  Future<String?> getPlatformVersion() {
    return IssScmsPlatform.instance.getPlatformVersion();
  }

  void init(){
    return IssScmsPlatform.instance.init();
  }

  void clearCache(int clearBeforeUnixTimeSeconds){
    IssScmsPlatform.instance.clearCache(clearBeforeUnixTimeSeconds);
  }

  Future<ValidateStatus> validate(List<int> bytes){
    return IssScmsPlatform.instance.validate(bytes, true);
  }

  void getDeviceCerts(String token){
    IssScmsPlatform.instance.getDeviceCerts(token, TokenType.DM_DASHBOARD);
  }

  Future<SigningApiState> getState(){
    return IssScmsPlatform.instance.getState();
  }

  Future<List<int>?> sign(int psid, List<int> bytes){
    return IssScmsPlatform.instance.sign(psid, bytes, null, null);
  }

  Future<ExpirationInformation> getExpirationInfo(){
    return IssScmsPlatform.instance.getExpirationInfo();
  }

  void topOffCerts(String token){
    IssScmsPlatform.instance.topOffCerts(token, TokenType.DM_DASHBOARD);
  }
  
}
