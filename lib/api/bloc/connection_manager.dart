import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/api/models/base_response.dart';
import 'package:netware/api/models/dictionary/dictionary_request.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/utils/logger.dart';
import '../models/base_request.dart';
import 'network.dart';
import 'operation.dart';

/// Global api parameter
ConnectionManager connectionManager;

class ConnectionManager {
  final logger = Logger('Api'); // TODO delete logger
  Dio _client;
  Dio _client2;
  Dio _clientSignUp;

//  StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  ConnectionManager() {
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
//    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    init(url: ApiHelper.baseUrl, isInit: true);
  }

  /// Main HTTP post request
  Future<Response> post(
    BaseRequest request, {
    bool hasCookie = false,
    dynamic requestData,
  }) async {
    Response response = Response();
    assert(request != null);
    logger.func = "post";
    try {
//      if (isOffline) {
//        response.statusCode = 400;
//        baseResponse =
//            BaseResponse(NO_INTERNET, getErrMsg(NO_INTERNET), 'Check connection');
//        response.data = baseResponse.toJson();
//        return response;
//      }

      /// Header
      Options options = Options();
      options.headers = hasCookie
          ? {
              "Connection": "Close",
              "Accept": "application/json",
              "Accept-Charset": "utf-8",
              "Content-Type": "application/json; charset=utf-8",
              "Cookie": 'NWSESSION=SELF_ENROLMENT',
              "Func": request.func,
              "Language": 0,
            }
          : {
              "Func": request.func,
              "Language": 0,
            };

      /// Request
      if (requestData != null) {
        // Датаг гаднаас авах
        response = await _client.post('', data: requestData, options: options);
      } else {
        // String map list
        var dataList = new List<Map<String, dynamic>>();
        dataList.add(request.toJson());
        logger.log(s: 2, m: request.toString(), m2: request.toJson());

        switch (request.func) {

          /// Cookie request: "SELF_ENROLMENT"
          // Sign up
          case Operation.stepID:
          case Operation.stepConfirmID:
          case Operation.stepAddress:
          case Operation.stepSelfie:
          case Operation.stepSendTAN:
          case Operation.stepVerifyTAN:
          // TermCond
          case Operation.termCond:
//            options = new Options(
//              method: 'POST',
//              responseType: ResponseType.json,
//              headers: {
//                "Connection": "Close",
//                "Accept": "application/json",
//                "Accept-Charset": "utf-8",
//                "Content-Type": "application/json; charset=utf-8",
//                "Cookie": 'NWSESSION=SELF_ENROLMENT',
//                "Func": request.func,
//                "Language": 0,
//              },
//            );

            BaseOptions baseOptions = BaseOptions();
            baseOptions.baseUrl = ApiHelper.baseUrl + ApiHelper.mainPath;
            baseOptions.receiveTimeout = 1000 * 120; //120second
            baseOptions.connectTimeout = 1000 * 60; //60second
            baseOptions.contentType = Headers.jsonContentType;
            baseOptions.headers = {
              "Connection": "Close",
              "Accept": "application/json",
              "Accept-Charset": "utf-8",
              "Content-Type": "application/json; charset=utf-8",
              "Cookie": 'NWSESSION=SELF_ENROLMENT',
              "Language": 0,
            };

            _clientSignUp.clear();
//            _clientSignUp.delete(;
            _clientSignUp = Dio(baseOptions);
//            CookieJar cookieJar = new CookieJar();
//            CookieManager cookieManager = new CookieManager(cookieJar);
//            _clientSignUp.interceptors.clear();
//            _clientSignUp.interceptors..add(cookieManager);
//            _clientSignUp.interceptors..add(LogInterceptor(requestBody: true, responseBody: true));
//            _clientSignUp.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));

            Options options1 = Options();
            options1.headers = {
              "Connection": "Close",
              "Accept": "application/json",
              "Accept-Charset": "utf-8",
              "Content-Type": "application/json; charset=utf-8",
              "Cookie": 'NWSESSION=SELF_ENROLMENT',
              "Func": request.func,
              "Language": 0,
            };

            response = await _clientSignUp.post('', data: dataList, options: options1);
            break;

          // String request: ["STRING"] //todo
          case Operation.getDictionaryData:
            List<String> list = new List<String>();
            list.add((request as DictionaryRequest).dictionaryCode);
            response = await _client.post('', data: list, options: options);
            break;

          default:
            response = await _client.post('', data: dataList, options: options);
            break;
        }
      }

      /// Response
      logger.log(s: 3, m: response);

      if (response.statusCode == 200) {
        /// SUCCESS
        logger.log(s: 4);

        Map<String, dynamic> mapData = Map<String, dynamic>();

        if (response.data == null) {
          /// Empty response
          mapData.putIfAbsent('resultCode', () => 0);
          mapData.putIfAbsent('resultDesc', () => '');
          response.data = mapData;
        } else if (response.data is String) {
          /// String response
          mapData.putIfAbsent('resultCode', () => 0);
          mapData.putIfAbsent('resultDesc', () => response.data);
          mapData.putIfAbsent('str', () => response.data);
          response.data = mapData;
        } else if (response.data is Map<String, dynamic>) {
          /// Map response
          // Response code
          mapData = response.data;
          if (mapData.containsKey('resCode')) {
            mapData.putIfAbsent('resultCode', () => mapData['resCode']);
          } else if (mapData.containsKey('resultCode')) {
            mapData.putIfAbsent('resultCode', () => mapData['resultCode']);
          } else {
            mapData.putIfAbsent('resultCode', () => 0);
          }

          // Response desc
          if (mapData.containsKey('resDesc')) {
            mapData.putIfAbsent('resultDesc', () => mapData['resDesc']);
          } else if (mapData.containsKey('resultDesc')) {
            mapData.putIfAbsent('resultDesc', () => mapData['resultDesc']);
          } else {
            mapData.putIfAbsent('resultDesc', () => '');
          }

          response.data = mapData;
        } else if (response.data is int) {
          /// Int response
          mapData.putIfAbsent('resultCode', () => 0);
          mapData.putIfAbsent('resultDesc', () => '');
          mapData.putIfAbsent('intValue', () => response.data);
          response.data = mapData;
          // } else if (response.data is List<dynamic>) {
          //   mapData.putIfAbsent('resultCode', () => 0);
          //   mapData.putIfAbsent('resultDesc', () => '');
          //   mapData.putIfAbsent('data', () => response.data);
          //   response.data = mapData;
        } else {
          /// Other response
          mapData.putIfAbsent('resultCode', () => 0);
          mapData.putIfAbsent('resultDesc', () => '');
//          response.data = mapData;
        }

//        if (request.func != Operation.logout) {
//          switch (baseResponse.resultCode) {
//            // Session timeout
//            case 9999999:
//            // Давхар login хийсэн
//            case 8888888:
//            case 7777777:
////              app.appBloc?.add(LoggedOut());
//              break;
//            default:
////              print(
////                "responseCode: ${baseResponse.responseCode}, responseDesc: ${baseResponse.responseDesc}",
////              );
//              break;
//          }
//        }
      } else {
        logger.log(s: 5);
      }
    } on DioError catch (error) {
      /// FAILED
      if (error.response != null) {
        response = error.response;
        response.data = BaseResponse.json(getResultCode(response.data), getResultDesc(response.data));
      } else {
        response.data = BaseResponse.json(ResponseCode.RequestFailed, getErrMsg(ResponseCode.RequestFailed, error.message));
      }

      // Session time out
      try {
        if (response.data.resultCode == ResponseCode.SessionExpired) {
          appBloc.add(LogoutEvent());
        }
      } catch (e) {
        print(e);
      }

      // HTML string error
      // https://github.com/flutter/flutter/issues/22951
      // remove proxy config for the Android emulator
      try {
        if (request.func == Operation.termCond && !Func.isEmpty(error.error?.source ?? '')) {
          Map<String, dynamic> mapData = Map<String, dynamic>();
          mapData.putIfAbsent('resultCode', () => 0);
          mapData.putIfAbsent('resultDesc', () => '');
          mapData.putIfAbsent('str', () => error.error.source);
          response.data = mapData;
        }
      } catch (e) {
        print(e);
      }

      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        response.statusCode = ResponseCode.RequestTimeout;
        response.data = BaseResponse.json(ResponseCode.RequestTimeout, getErrMsg(ResponseCode.RequestTimeout, error.message));
      }

      logger.log(s: 10, m: "DioError Exception: $error");
    } catch (error, stacktrace) {
      print(error);
      logger.log(s: 11, m: "Exception occured: $error stackTrace: $stacktrace");

      response.data = BaseResponse.json(ResponseCode.RequestFailed, getErrMsg(ResponseCode.RequestFailed, error.message));
    }

//    if (request.func == Operation.getLoanList) {
//      appBloc.add(LogoutEvent());
//    }

    return response;
  }

  void connectionChanged(dynamic hasConnection) {
    isOffline = !hasConnection;
  }

  void init({
    @required String url,
    bool isInit = false, // URL өөрчлөгдсөн бол client-ийг дахин тодорхойлно
  }) {
    /// Update base url
    if (isInit) ApiHelper.baseUrl = url;

    /// Main http client
    if (null == _client || isInit) {
      logger.func = "_internal";

      logger.log(s: 1);

      BaseOptions options = BaseOptions();
      options.baseUrl = url + ApiHelper.mainPath;
      options.receiveTimeout = 1000 * 120; //120second
      options.connectTimeout = 1000 * 60; //60second
      options.contentType = Headers.jsonContentType; //ContentType.parse("application/json");
      //options.contentType= ContentType.parse("application/x-www-form-urlencoded");
      options.headers = {
        "Connection": "Close",
        "Accept": "application/json",
        "Accept-Charset": "utf-8",
        "Content-Type": "application/json; charset=utf-8",
        "Language": 0,
      };

      _client = Dio(options);

      _client.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));
    } else {
      logger.log(s: 2);
    }

    /// SecondaryClient

    /// Sign up http client
    if (_clientSignUp == null || isInit) {
      logger.func = "_internal";

      logger.log(s: 1);

      BaseOptions options = BaseOptions();
      options.baseUrl = url + ApiHelper.mainPath;
      options.receiveTimeout = 1000 * 120; //120second
      options.connectTimeout = 1000 * 60; //60second
      options.contentType = Headers.jsonContentType;
      options.headers = {
        "Connection": "Close",
        "Accept": "application/json",
        "Accept-Charset": "utf-8",
        "Content-Type": "application/json; charset=utf-8",
        "Cookie": 'NWSESSION=SELF_ENROLMENT',
        "Language": 0,
      };

      _clientSignUp = Dio(options);

//      _clientSignUp.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  /// Multipart/form-data HTTP post request
  Future<String> postMultipart({File file}) async {
    String result = "";
    try {
      if (file == null) return "";

      Dio client = new Dio();
//      client.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));

      FormData formData = new FormData.fromMap({
        "filename": await MultipartFile.fromFile(file.path, filename: "image.jpg"),
      });

      await client
          .post(
        ApiHelper.baseUrl + ApiHelper.fileUploadPath,
        data: formData,
        options: Options(
          method: 'POST',
          responseType: ResponseType.plain,
          headers: {
            "Cookie": 'NWSESSION=SELF_ENROLMENT',
            "Language": 0,
          },
        ),
      )
          .then((response) {
        if (response.statusCode == 200) {
          result = response.data.toString().replaceAll('\"', "").replaceAll("\n", "");
        } else {
          result = "";
        }
      }).catchError((error) {
        print(error);
        result = getErrMsg(ResponseCode.RequestFailed, error);
      });

      return result;
    } catch (e) {
      print(e);
      result = getErrMsg(ResponseCode.RequestFailed, e);
      return "";
    }
  }

  // TODO delete
  Future<Map<String, dynamic>> get(String path, [Map<String, dynamic> params]) async {
    Response<Map<String, dynamic>> response;
    if (null != params) {
      response = await _client.get(path, queryParameters: params);
    } else {
      response = await _client.get(path);
    }
    return response.data;
  }

  String getErrMsg(int errCode, [String detail]) {
    String msg = "Error $errCode";
    switch (errCode) {
      case ResponseCode.RequestFailed:
        msg = '${globals.text?.requestFailed() ?? "Request failed"} ';
        break;

      case ResponseCode.RequestTimeout:
        msg = '${globals.text?.execTimeout() ?? "Failed to perform action! Timeout"} ';
        break;

      case ResponseCode.BadRequest:
        msg = '${globals.text?.checkInternet() ?? "Please check internet connection!"} ';
        break;
    }
    return msg;
  }

  int getResultCode(String str) {
    int result = ResponseCode.RequestFailed;
    try {
      String val = Func.toStr(str);
      if (val.contains('-')) {
        result = int.parse(val.split('-')[0].trim());
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

//  String getResultDesc(String str) {
//    String result = '';
//    try {
//      result = Func.toStr(str);
//      if (result.contains('-')) {
//        result = result.split('-')[1].trim();
//      }
//    } catch (e) {
//      print(e);
//    }
//    return result;
//  }

  String getResultDesc(String s) {
    String result = '';
    try {
      result = Func.toStr(s);
      if (s.contains('-')) {
        int idx = s.indexOf('-');
        List parts = [s.substring(0, idx).trim(), s.substring(idx + 1).trim()];
        result = parts[1];
      }
    } catch (e) {
      print(e);
    }

    return result;
  }
}
