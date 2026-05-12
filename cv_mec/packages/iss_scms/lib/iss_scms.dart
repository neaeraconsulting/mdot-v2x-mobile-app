library iss_scms;

import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:iss_scms/iss_signing_api_service.dart';
import 'package:iss_scms/models/expiration_information.dart';
import 'package:iss_scms/models/signing_api_state.dart';
import 'package:iss_scms/models/token_type.dart';
import 'package:iss_scms/models/validate_status.dart';

import 'iss_scms_platform_interface.dart';

class IssScms {

  late IssSigningApiService apiService;

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
      if (state == SigningApiState.READY) {
        return; // Condition met, exit the function
      }
      await Future.delayed(checkInterval);
    }
  }

  // Message Definition Matches ISS Library
  void init() async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Initializing SCMS for Mobile");
      return IssScmsPlatform.instance.init();
    } else {
      apiService = Get.put(IssSigningApiService());
    } 
  }

  void clearCache(int clearBeforeUnixTimeSeconds){
    if (Platform.isAndroid || Platform.isIOS) {
      IssScmsPlatform.instance.clearCache(clearBeforeUnixTimeSeconds);
    } else {
      apiService.clearCache(clearBeforeUnixTimeSeconds);
    }
  }

  Future<ValidateStatus> validate(List<int> bytes){
    if (Platform.isAndroid || Platform.isIOS) {
      return IssScmsPlatform.instance.validate(bytes, true);
    } else {
      return apiService.validate(bytes);
    }
  }

  void getDeviceCerts(String token){
    if (Platform.isAndroid || Platform.isIOS) {
      IssScmsPlatform.instance.getDeviceCerts(token, TokenType.DM_DASHBOARD);
    } else {
      apiService.getDeviceCerts(token, TokenType.DM_DASHBOARD);
    }
  }

  Future<SigningApiState> getState(){
    if (Platform.isAndroid || Platform.isIOS) {
      return IssScmsPlatform.instance.getState();
    } else {
      return apiService.getState();
    }
  }

  Future<List<int>?> sign(int psid, List<int> bytes){
    if (Platform.isAndroid || Platform.isIOS) {
      return IssScmsPlatform.instance.sign(psid, bytes, null, null);
    } else {
      return apiService.sign(psid, bytes, null, null);
    }
  }

  Future<ExpirationInformation> getExpirationInfo(){
    return IssScmsPlatform.instance.getExpirationInfo();
  }

  void topOffCerts(String token){
    if (Platform.isAndroid || Platform.isIOS) {
      IssScmsPlatform.instance.topOffCerts(token, TokenType.DM_DASHBOARD);
    } else {
      apiService.topOffCerts(token, TokenType.DM_DASHBOARD);
    }
  }
  
}
