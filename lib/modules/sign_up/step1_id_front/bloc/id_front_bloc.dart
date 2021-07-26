import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/modules/sign_up/api/sign_up_repository.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_confirm_request.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_confirm_response.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_request.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_response.dart';
import 'package:netware/app/utils/func.dart';

import '../../sign_up_helper.dart';
import 'id_front_event.dart';
import 'id_front_state.dart';

class IdFrontBloc extends Bloc<IdFrontEvent, IdFrontState> {
  @override
  IdFrontState get initialState => IdFrontInit();

  @override
  Stream<IdFrontState> mapEventToState(IdFrontEvent event) async* {
    if (event is IdFrontUploadImage) {
      yield* _mapUploadImageToState(file: event.file);
    } else if (event is IdFrontConfirm) {
      yield* _mapIdConfirmToState(idFrontResponse: event.idFrontResponse);
    }
  }

  Stream<IdFrontState> _mapUploadImageToState({File file}) async* {
    yield IdFrontLoading();

//    yield IdFrontFailed();
//    return;

    try {
      String fileName;

      if (globals.isTest) {
//        fileName = '61d8a6ea-8080-48ce-8fd6-cc0829a27e13.jpg';
      } else {
        fileName = await connectionManager.postMultipart(file: file);
      }

      if (!Func.isEmpty(fileName)) {
        SignUpRepository repository = new SignUpRepository();
        IdFrontRequest request = new IdFrontRequest(idImg: fileName);
        IdFrontResponse response = await repository.stepId(request);

        if (response.resultCode == 0) {
          SignUpHelper.userKey = response.userKey;
          SignUpHelper.stepNo = 1;
          yield IdFrontSuccess(idFrontResponse: response);
        } else {
          SignUpHelper.clear();
          yield IdFrontFailed(resDesc: response.resultDesc);
        }
      } else {
        yield IdFrontFailed(resDesc: 'Алдаа гарлаа');
      }
    } catch (e) {
      print(e);
      yield IdFrontFailed(resDesc: 'Алдаа гарлаа');
    }
  }

  Stream<IdFrontState> _mapIdConfirmToState({IdFrontResponse idFrontResponse}) async* {
    try {
//      yield IdFrontConfirmFailed(resDesc: 'Алдаа гарлаа');
//      return;

      SignUpRepository repository = new SignUpRepository();
      IdFrontConfirmRequest request = new IdFrontConfirmRequest(
        userKey: idFrontResponse.userKey,
        regNo: idFrontResponse.regNo,
        lastName: idFrontResponse.lastName,
        firstName: idFrontResponse.firstName,
        sex: idFrontResponse.sex,
      );

      IdFrontConfirmResponse response = await repository.stepConfirmID(request);

      if (response.resultCode == 0) {
        yield IdFrontConfirmSuccess();
      } else {
        yield IdFrontConfirmFailed(
          resDesc: !Func.isEmpty(response.resultDesc) ? response.resultDesc : 'Алдаа гарлаа',
        );
      }
    } catch (e) {
      print(e);
      yield IdFrontConfirmFailed(resDesc: 'Алдаа гарлаа');
    }
  }

  IdFrontResponse getTestResponse() {
    //      fileName = 'bcc5b19a-007f-4e79-a010-eb0c19180a34.jpg';
    //61d8a6ea-8080-48ce-8fd6-cc0829a27e13.jpg //jagaa
    //[{"idImg": "bc574739-589c-485d-8cca-0436bfd83c65.jpg"}] //khayri

    // 9ce091a0-9f20-4bb0-88ff-847f20fd85cb.jpg //ts

    return IdFrontResponse()
      ..firstName = 'ЖАРГАЛБАТ'
      ..lastName = 'Жалбуу'
      ..regNo = 'ЕЛ89103134'
//      ..sex = 'M'
      ..userKey = '2002250214_7ECF8FF6-E620-4AAC-A8F7-4ABF85916E08';

//    {
//      "regNo": "ЕЛ89103134",
//    "isRegnoEdited": 0,
//    "lastName": "Жалбуу",
//    "isLastnameEdited": 0,
//    "resultCode": 0,
//    "isFirstnameEdited": 0,
//    "isSexEdited": 0,
//    "resultDesc": "",
//    "userKey": "2002250214_7ECF8FF6-E620-4AAC-A8F7-4ABF85916E08",
//    "reqId": 0,
//    "idStatus": "S",
//    "firstName": "ЖАРГАЛБАТ",
//    "idFullText": "",
//    "idImg": "61d8a6ea-8080-48ce-8fd6-cc0829a27e13.jpg"
//  }
  }
}
