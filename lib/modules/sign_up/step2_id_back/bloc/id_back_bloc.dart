import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/modules/sign_up/api/sign_up_repository.dart';
import 'package:netware/modules/sign_up/step2_id_back/api/id_back_request.dart';
import 'package:netware/modules/sign_up/step2_id_back/api/id_back_response.dart';
import 'package:netware/app/utils/func.dart';
import '../../sign_up_helper.dart';
import 'id_back_event.dart';
import 'id_back_state.dart';

class IdBackBloc extends Bloc<IdBackEvent, IdBackState> {
  @override
  IdBackState get initialState => IdBackInit();

  @override
  Stream<IdBackState> mapEventToState(IdBackEvent event) async* {
    if (event is IdBackUploadImage) {
      yield* _mapSendImageToState(file: event.file, userKey: event.userKey);
    }
  }

  Stream<IdBackState> _mapSendImageToState({File file, String userKey}) async* {
    yield IdBackLoading();

    try {
      String fileName;

      if (globals.isTest) {
//        fileName = 'b9313397-c4f1-41fd-a592-c77ba6742cf2.jpg';
      } else {
        fileName = await connectionManager.postMultipart(file: file);
      }

      if (!Func.isEmpty(fileName)) {
        SignUpRepository repository = new SignUpRepository();
        IdBackRequest request = new IdBackRequest(userKey: userKey, idbackImg: fileName);
        IdBackResponse response = await repository.stepAddress(request);

        if (response.resultCode == 0) {
          SignUpHelper.stepNo = 2;
          yield IdBackSuccess(idBackResponse: response);
        } else {
          SignUpHelper.stepNo = 1;
          yield IdBackFailed(resDesc: response.resultDesc);
        }
      } else {
        yield IdBackFailed();
      }
    } catch (e) {
      print(e);
      yield IdBackFailed();
    }
  }

  IdBackResponse getTestResponse() {
    return IdBackResponse()
      ..isRegnoEdited = 0
      ..userKey = '2002250214_7ECF8FF6-E620-4AAC-A8F7-4ABF85916E08'
      ..addrFullText =
          "Ол кен байгууллага нидани аниеthеrе ity\nУлсын бүртгэлийн Ерөнхий Газар\nThe General Authonty for State Registration\nолгосон он, сар, өдөр банее не винаги\n2012/05/16\nХүчинтэй хугацаа бие сай екрану\n0000/00/00\nХаг\nУБ, Сонгинохайрхан, 15-р хороо\nөнөр хороолол, 20 байр\n258 toor\nMNG\n";
  }
}
