import 'dart:async';
import 'package:netware/api/bloc/connection_manager.dart';
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

class SignUpApi {
  Future<IdFrontResponse> stepId(IdFrontRequest request) async {
    return IdFrontResponse.fromJson((await connectionManager.post(request, hasCookie: true)).data);
  }

  Future<IdFrontConfirmResponse> stepConfirmID(IdFrontConfirmRequest request) async {
    return IdFrontConfirmResponse.fromJson((await connectionManager.post(request, hasCookie: true)).data);
  }

  Future<IdBackResponse> stepAddress(IdBackRequest request) async {
    return IdBackResponse.fromJson((await connectionManager.post(request, hasCookie: true)).data);
  }

  Future<IdSelfieResponse> stepSelfie(IdSelfieRequest request) async {
    return IdSelfieResponse.fromJson((await connectionManager.post(request, hasCookie: true)).data);
  }

  Future<SendTanResponse> stepSendTan(SendTanRequest request) async {
    return SendTanResponse.fromJson((await connectionManager.post(request, hasCookie: true)).data);
  }

  Future<VerifyTanResponse> stepVerifyTan(VerifyTanRequest request) async {
    return VerifyTanResponse.fromJson((await connectionManager.post(request, hasCookie: true)).data);
  }
}
