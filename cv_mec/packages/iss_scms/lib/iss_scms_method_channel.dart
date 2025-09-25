import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:iss_scms/models/signing_api_state.dart';
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
  Future<SigningApiState> getState() async {
    String? signingApiState = await methodChannel.invokeMethod<String?>('getState');
    return enumFromString(signingApiState, SigningApiState.values, SigningApiState.NEED_CERTS);
  }

  @override
  Future<ValidateStatus> validate(List<int> bytes, bool shouldValidate) async{
    String? valid = await methodChannel.invokeMethod<String?>('validate', {'message': bytes, 'shouldValidate': shouldValidate});
    return enumFromString(valid, ValidateStatus.values, ValidateStatus.FAILURE);
  }

  @override
  void topOffCerts(String token, TokenType tokenType){
    methodChannel.invokeMethod<List<int>?>('topOffCerts', {'token': token, 'tokenType': tokenType.index});
  }

  T enumFromString<T extends Enum>(String? value, List<T> values, T def) {
    try {
      return values.firstWhere((e) => e.name == value);
    } catch (_) {
      return def; // return null if no match
    }
  }
}
