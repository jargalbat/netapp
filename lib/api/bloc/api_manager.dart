import 'package:dio/dio.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/acnt/get_acnt_detail_request.dart';
import 'package:netware/api/models/acnt/get_acnt_detail_response.dart';
import 'package:netware/api/models/acnt/add_bank_acnt_request.dart';
import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
import 'package:netware/api/models/acnt/remove_bank_acnt_request.dart';
import 'package:netware/api/models/acnt/update_bank_acnt_request.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/base_response.dart';
import 'package:netware/api/models/customer/update_cust_addition_request.dart';
import 'package:netware/api/models/dictionary/dictionary_request.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/loan/create_loan_request.dart';
import 'package:netware/api/models/loan/extend_info_response.dart';
import 'package:netware/api/models/loan/get_extend_info_request.dart';
import 'package:netware/api/models/loan/get_loan_acnt_offline_info_request.dart';
import 'package:netware/api/models/loan/get_pay_info_offline_request.dart';
import 'package:netware/api/models/loan/get_pay_info_request.dart';
import 'package:netware/api/models/loan/limit_fee_score_response.dart';
import 'package:netware/api/models/loan/loan_list_response.dart';
import 'package:netware/api/models/loan/loan_prod_response.dart';
import 'package:netware/api/models/loan/offline_loan_list_response.dart';
import 'package:netware/api/models/loan/offline_pay_info_response.dart';
import 'package:netware/api/models/loan/online_pay_info_response.dart';
import 'package:netware/api/models/net_point/use_bonus_fee_request.dart';
import 'package:netware/api/models/net_point/use_bonus_limit_request.dart';
import 'package:netware/api/models/notification/notif_list_response.dart';
import 'package:netware/api/models/password/change_password_request.dart';
import 'package:netware/api/models/password/change_password_response.dart';
import 'package:netware/api/models/password/reset_password_request.dart';
import 'package:netware/api/models/password/reset_password_response.dart';
import 'package:netware/api/models/qpay/create_qpay_qrcode_request.dart';
import 'package:netware/api/models/qpay/create_qpay_qrcode_response.dart';
import 'package:netware/api/models/settings/add_relative_request.dart';
import 'package:netware/api/models/settings/bind_fb_request.dart';
import 'package:netware/api/models/settings/branch_list_response.dart';
import 'package:netware/api/models/settings/device_list_response.dart';
import 'package:netware/api/models/settings/get_profile_response.dart';
import 'package:netware/api/models/settings/relative_list_response.dart';
import 'package:netware/api/models/settings/remove_device_request.dart';
import 'package:netware/api/models/settings/remove_relative_request.dart';
import 'package:netware/api/models/settings/settings_link_response.dart';
import 'package:netware/api/models/settings/update_biometric_request.dart';
import 'package:netware/api/models/settings/update_profile_pic_request.dart';
import 'package:netware/api/models/settings/update_profile_pic_response.dart';
import 'package:netware/api/models/settings/update_profile_request.dart';
import 'package:netware/api/models/settings/update_relative_request.dart';
import 'package:netware/api/models/term_cond/term_cond_response.dart';

class ApiManager {
  static const String APP_STORE_USER_MOBILE = "55558888";
  static const String APP_STORE_USER_DEVICE = "deviceCode";
  static const String APP_STORE_USER_BASE_URL = "http://34.70.15.87:8080/netware.mw.web/gate";

  /// Dictionary
  static Future<DictionaryResponse> getDictionaryData(DictionaryRequest request) async {
    Response response = await connectionManager.post(request..func = Operation.getDictionaryData);

    return DictionaryResponse.fromJson(response.data);
  }

  static Future<BranchListResponse> getBranchList() async {
    return BranchListResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getBranches4Mobile, requestData: [])).data);
  }

  /// Terms & Condition
  static Future<TermCondResponse> getTermCond() async {
    return TermCondResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.termCond, requestData: [], hasCookie: true)).data);
  }

  /// Notification
  static Future<NotifListResponse> getNotifList() async {
    var json = (await connectionManager.post(BaseRequest()..func = Operation.getNotifications, requestData: [])).data;
    var res = NotifListResponse.fromJson(json);
    return res;
  }

  /// Password
  static Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    return ChangePasswordResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request) async {
    return ResetPasswordResponse.fromJson((await connectionManager.post(request)).data);
  }

  /// Settings
  static Future<BaseResponse> bindFb(BindFbRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<BaseResponse> unbindFb() async {
    return BaseResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.unbindFb, requestData: [])).data);
  }

  static Future<SettingsLinkResponse> getSettingsLinks() async {
    return SettingsLinkResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getOperatorInfo, requestData: [])).data);
  }

  static Future<BaseResponse> updateBiometric(UpdateBiometricRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.updateBiometric, requestData: [
      request.deviceCode,
      request.biometricAuth,
    ]))
        .data);
  }

  /// Profile
  static Future<GetProfileResponse> getProfile() async {
    return GetProfileResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getProfile, requestData: [])).data);
  }

  static Future<BaseResponse> updateProfile(UpdateProfileRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<UpdateProfilePicResponse> updateProfilePic(UpdateProfilePicRequest request) async {
    return UpdateProfilePicResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<RelativeListResponse> selectRelative() async {
    return RelativeListResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.selectRelative, requestData: [])).data);
  }

  static Future<BaseResponse> insertRelative(AddRelativeRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<BaseResponse> updateRelative(UpdateRelativeRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<BaseResponse> updateCustAddition(UpdateCustAdditionRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<BaseResponse> deleteRelative(RemoveRelativeRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request, requestData: [request.relativeId])).data);
  }

  static Future<BaseResponse> detailRelative(BaseRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request..func = Operation.detailRelative)).data);
  }

  static Future<DeviceListResponse> selectUserDevice() async {
    return DeviceListResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.selectUserDevice, requestData: [])).data);
  }

  static Future<BaseResponse> deleteUserDevice(RemoveDeviceRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<BaseResponse> insertAdditionalProfile(BaseRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  /// Account
  static Future<BankAcntListResponse> getBankAcntList() async {
    return BankAcntListResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.selectBankAcnt, requestData: [])).data);
  }

  static Future<BaseResponse> addBankAcnt(AddBankAcntRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<BaseResponse> deleteBankAcnt(RemoveBankAcntRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request, requestData: [request.bankCode])).data);
  }

  static Future<BaseResponse> updateBankAcnt(UpdateBankAcntRequest request) async {
//    return BaseResponse.fromJson((await connectionManager.post(request, requestData: [request.custCode, request.bankCode, request.isMain])).data);
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  /// Loan
  static Future<LoanProdResponse> getLoanProd() async {
    return LoanProdResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.loanProd, requestData: [])).data);
  }

  static Future<FeeScoreResponse> getLimitFeeScore() async {
    return FeeScoreResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getLimitAndScore, requestData: [])).data);
  }

  static Future<OnlineLoanListResponse> getLoanList() async {
    return OnlineLoanListResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getLoanList, requestData: [])).data);
  }

  static Future<OfflineLoanListResponse> getLoanAcntsOffline() async {
    return OfflineLoanListResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getLoanAcntsOffline, requestData: [])).data);
  }

  static Future<BaseResponse> getLoanAcntOfflineInfo(GetLoanAcntOfflineInfoRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request, requestData: [request.acntNo])).data);
  }

  static Future<BaseResponse> createLoanRequest(CreateLoanRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request)).data);
  }

  static Future<AcntDetailResponse> getAcntDetail(GetAcntDetailRequest request) async {
    return AcntDetailResponse.fromJson((await connectionManager.post(request, requestData: [request.acntNo])).data);
  }

  static Future<AcntDetailResponse> getOfflineAcntDetail(GetOfflineAcntDetailRequest request) async {
    return AcntDetailResponse.fromJson((await connectionManager.post(request, requestData: [request.acntNo])).data);
  }

  static Future<ExtendInfoResponse> getExtendInfo(GetExtendInfoRequest request) async {
    return ExtendInfoResponse.fromJson((await connectionManager.post(request, requestData: [request.acntNo])).data);
  }

  static Future<OnlinePayInfoResponse> getPayInfoOnline(GetPayInfoOnlineRequest request) async {
    return OnlinePayInfoResponse.fromJson((await connectionManager.post(request, requestData: [request.acntNo])).data);
  }

  static Future<OfflinePayInfoResponse> getPayInfoOffline(GetPayInfoOfflineRequest request) async {
    return OfflinePayInfoResponse.fromJson((await connectionManager.post(request, requestData: [request.acntNo])).data);
  }

  static Future<CreateQpayQrCodeResponse> createQpayQrCode(CreateQpayQrCodeRequest request) async {
    return CreateQpayQrCodeResponse.fromJson(
      (await connectionManager.post(request, requestData: [request.acntCode, request.termSize, request.paymentCode])).data,
    );
  }

  /// Net point
  static Future<BaseResponse> useBonusLimit(UseBonusLimitRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request, requestData: [request.score])).data);
  }

  static Future<BaseResponse> useBonusFee(UseBonusFeeRequest request) async {
    return BaseResponse.fromJson((await connectionManager.post(request, requestData: [request.score])).data);
  }

  /// Notification
  static Future<BaseResponse> getNotifications() async {
    return BaseResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.getNotifications, requestData: [])).data);
  }

  static Future<BaseResponse> readNotifications() async {
    return BaseResponse.fromJson((await connectionManager.post(BaseRequest()..func = Operation.readNotifications, requestData: [])).data);
  }
}
