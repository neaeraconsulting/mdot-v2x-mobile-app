library iss_scms;

import 'dart:async';

import 'package:iss_scms/models/expiration_information.dart';
import 'package:iss_scms/models/signing_api_state.dart';
import 'package:iss_scms/models/token_type.dart';
import 'package:iss_scms/models/validate_status.dart';

import 'iss_scms_platform_interface.dart';

class IssScms {
  
  IssScms(){
    init();
  }


  // Helper Method to perform on necessary checks to prepare the SCMS for Signing
  Future<bool> activateScms(String token) async{

    SigningApiState state = await getState();

    if(state == SigningApiState.NEED_INIT){
      init();
      state = await getState();
    }

    if(state == SigningApiState.NEED_CERTS){
      getDeviceCerts(token);
      await waitUntilCertsDownloaded();
      state = await getState();
    }
    
    if(state == SigningApiState.READY){
      // topOffCerts(token);
      return true;
    }
    

    return false;
  }
  

  Future<void> waitUntilCertsDownloaded({
    Duration checkInterval = const Duration(milliseconds: 100),
    Duration timeout = const Duration(seconds: 50),
  }) async {
    final start = DateTime.now();
    while (DateTime.now().difference(start) < timeout) {
      SigningApiState state = await getState();
      print("SCMS Checking State ${state.name}");
      if (state == SigningApiState.READY) {
        return; // Condition met, exit the function
      }
      await Future.delayed(checkInterval);
    }
  }

  // Message Definition Matches ISS Library
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
