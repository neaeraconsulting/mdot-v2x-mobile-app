import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:iss_scms/models/token_type.dart';
import 'package:iss_scms/models/validate_status.dart';

import 'iss_scms_platform_interface.dart';

/// An implementation of [IssScmsPlatform] that uses method channels.
class MethodChannelIssScms extends IssScmsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('iss_scms');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void init(){
    methodChannel.invokeMethod<bool>('init');
  }

  @override
  Future<List<int>?> sign(int psid, List<int> tbsOer, int? jIndex, bool? digestSigner) async{
    final signed = await methodChannel.invokeMethod<List<int>?>('sign', {'psid': psid, 'tbsOer': tbsOer, 'jIndex': null, 'digestSigner': null});
    return signed;
  }

  @override
  void getDeviceCerts(String token, TokenType tokenType){
    methodChannel.invokeMethod<List<int>?>('getDeviceCerts', {'token': token, 'tokenType': tokenType.index});
  }

  @override
  Future<ValidateStatus> validate(List<int> bytes, bool shouldValidate) async{
    int? valid = await methodChannel.invokeMethod<int?>('validate', {'message': bytes, 'shouldValidate': shouldValidate});
    if(valid != null && valid >= 0 && valid < ValidateStatus.values.length){
      return ValidateStatus.values[valid];
    }else{
      return ValidateStatus.FAILURE;
    }

    
  }
}
