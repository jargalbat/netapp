import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/modules/sign_up/api/sign_up_repository.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/api/id_selfie_request.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/api/id_selfie_response.dart';
import 'package:netware/app/utils/func.dart';
import '../../sign_up_helper.dart';
import 'id_selfie_event.dart';
import 'id_selfie_state.dart';

class IdSelfieBloc extends Bloc<IdSelfieEvent, IdSelfieState> {
  @override
  IdSelfieState get initialState => IdSelfieInit();

  @override
  Stream<IdSelfieState> mapEventToState(IdSelfieEvent event) async* {
    if (event is IdSelfieUploadImage) {
      yield* _mapSendImageToState(file: event.file, userKey: event.userKey);
    }
  }

  Stream<IdSelfieState> _mapSendImageToState({File file, String userKey}) async* {
    yield IdSelfieLoading();

    try {
      String fileName;

      if (globals.isTest) {
//        fileName = 'ee0f3c88-ae9c-452f-8fef-5a245d624f09.jpg';
//        fileName = '41cefa4a-81e5-4190-8794-331ae009cf02.jpg';

      } else {
        fileName = await connectionManager.postMultipart(file: file);
      }

      if (!Func.isEmpty(fileName)) {
        SignUpRepository repository = new SignUpRepository();
        IdSelfieRequest request = new IdSelfieRequest(userKey: userKey, selfieImg: fileName);
        IdSelfieResponse response = await repository.stepSelfie(request);

        if (response.resultCode == 0) {
          SignUpHelper.stepNo = 3;
          yield IdSelfieSuccess(idSelfieResponse: response);
        } else {
          SignUpHelper.stepNo = 2;
          yield IdSelfieFailed(resDesc: response.resultDesc);
        }
      } else {
        yield IdSelfieFailed();
      }
    } catch (e) {
      print(e);
      yield IdSelfieFailed();
    }
  }

  IdSelfieResponse getTestResponse() {
    return IdSelfieResponse()..userKey = 'Test';
  }
}
