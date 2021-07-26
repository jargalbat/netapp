import 'dart:async';

import 'package:netware/modules/sign_up/step1_id_front/api/id_front_confirm_request.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_confirm_response.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_request.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_response.dart';
import 'package:netware/modules/sign_up/step2_id_back/api/id_back_request.dart';
import 'package:netware/modules/sign_up/step2_id_back/api/id_back_response.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/api/id_selfie_request.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/api/id_selfie_response.dart';
import 'package:netware/modules/sign_up/step4_mobile/api/send_tan_request.dart';
import 'package:netware/modules/sign_up/step4_mobile/api/send_tan_response.dart';
import 'package:netware/modules/sign_up/step5_tan/api/verify_tan_request.dart';
import 'package:netware/modules/sign_up/step5_tan/api/verify_tan_response.dart';

import 'sign_up_api.dart';

class SignUpRepository {
  final SignUpApi _signUpApi = SignUpApi();

  static SignUpRepository _instance;

  factory SignUpRepository() {
    if (_instance == null) {
      _instance = SignUpRepository._internal();
    }
    return _instance;
  }

  SignUpRepository._internal();

  Future<IdFrontResponse> stepId(IdFrontRequest request) async {
    return await _signUpApi.stepId(request);
  }

  Future<IdFrontConfirmResponse> stepConfirmID(IdFrontConfirmRequest request) async {
    return await _signUpApi.stepConfirmID(request);
  }

  Future<IdBackResponse> stepAddress(IdBackRequest request) async {
    return await _signUpApi.stepAddress(request);
  }

  Future<IdSelfieResponse> stepSelfie(IdSelfieRequest request) async {
    return await _signUpApi.stepSelfie(request);
  }

  Future<SendTanResponse> stepSendTan(SendTanRequest request) async {
    return await _signUpApi.stepSendTan(request);
  }

  Future<VerifyTanResponse> stepVerifyTan(VerifyTanRequest request) async {
    return await _signUpApi.stepVerifyTan(request);
  }
}
