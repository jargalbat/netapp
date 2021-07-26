import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

import 'l10n/messages_all.dart';

class LangCode {
  static const String mn = "mn";
  static const String en = "en";
}

const String MN = "mn";
const String EN = "en";

final List<String> supportedLanguages = [
  "MN",
  "EN",
];

final List<String> supportedLanguagesCodes = ["mn", "en"];

final Map<dynamic, dynamic> languagesNameMap = {
  supportedLanguagesCodes[0]: supportedLanguages[0],
  supportedLanguagesCodes[1]: supportedLanguages[1],
};

String languageName(String langCode) {
  return languagesNameMap[langCode];
}

String languageNameDisplay(String langCode) {
  return languageName(languageCodeSwap(langCode));
}

Locale newLocale(String langCode) {
  return Locale(languageCodeSwap(langCode));
}

String languageCodeSwap(String langCode) {
  if (Func.isEmpty(langCode)) {
    langCode = MN;
  }
  if (MN == langCode) {
    langCode = EN;
  } else {
    langCode = MN;
  }

  return langCode;
}

class Localization {
  static Future<Localization> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      Localization l = Localization();
      globals.text = l;
      return l;
    });
  }

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  /// Global
  skip() => Intl.message('skip');

  cancel() => Intl.message('cancel');

  close() => Intl.message('close');

  delete() => Intl.message('delete');

  remove() => Intl.message('remove');

  String use() => Intl.message('use');

  String pay() => Intl.message('pay');

  String confirm() => Intl.message('confirm');

  String bank() => Intl.message('bank');

  String fee() => Intl.message('fee');

  title() => Intl.message(
        'title',
        name: 'Netware',
        desc: 'Netware',
      );

  text(counter) => Intl.message(
        'You have pushed the button $counter times:',
        name: 'text',
        args: [counter],
        desc: 'Our Text to localize',
      );

  /// Login
  String mobile() => Intl.message('mobile');

  password() => Intl.message('password');

  forgotPassword() => Intl.message('forgotPassword');

  forgotPasswordQuestion() => Intl.message('forgotPasswordQuestion');

  login() => Intl.message('login');

  signUp() => Intl.message('signUp');

  String rememberMe() => Intl.message('rememberMe');

  String validMobile() => Intl.message('validMobile');

  String validPassword() => Intl.message('validPassword');

  String welcome() => Intl.message('welcome');

  String msgChangePass() => Intl.message('msgChangePass');

  String msgExpiredPass() => Intl.message('msgExpiredPass');

  String deviceHint() => Intl.message('deviceHint');

  /// Password
  String currentPass() => Intl.message('currentPass');

  String newPass() => Intl.message('newPass');

  String newPassRepeat() => Intl.message('newPassRepeat');

  String incorrectNewPassRepeat() => Intl.message('incorrectNewPassRepeat');

  String successChangePass() => Intl.message('successChangePass');

  String changePassword() => Intl.message('changePassword');

  String invalidMobile() => Intl.message('invalidMobile');

  String goToLogin() => Intl.message('goToLogin');

  String loginScreen() => Intl.message('loginScreen');

  String changePass() => Intl.message('changePass');

  /// Bond
  buyBond() => Intl.message('buyBond');

  myPacket() => Intl.message('myPacket');

  specialOfferings() => Intl.message('specialOfferings');

  month() => Intl.message('month');

  promotion() => Intl.message('promotion');

  news() => Intl.message('news');

  more() => Intl.message('more');

  buy() => Intl.message('buy');

  sell() => Intl.message('sell');

  msgMobileTan() => Intl.message('msgMobileTan');

  getTanCode() => Intl.message('getTanCode');

  tanCode() => Intl.message('tanCode');

  msgSentTan() => Intl.message('msgSentTan');

  String contin() => Intl.message('contin');

  createPassword() => Intl.message('createPassword');

  msgCreatePassword() => Intl.message('msgCreatePassword');

  repeatPassword() => Intl.message('repeatPassword');

  back() => Intl.message('back');

  done() => Intl.message('done');

  msgSignUpSuccessTitle() => Intl.message('msgSignUpSuccessTitle');

  msgRegisterSuccessBody() => Intl.message('msgRegisterSuccessBody');

  verify() => Intl.message('verify');

  verification() => Intl.message('verification');

  sendAgain() => Intl.message('sendAgain');

  msgInsertTan() => Intl.message('msgInsertTan');

  agree() => Intl.message('agree');

  yes() => Intl.message('yes');

  no() => Intl.message('no');

  String lastName() => Intl.message('lastName');

  String firstName() => Intl.message('firstName');

  bond() => Intl.message('bond');

  bonds() => Intl.message('bonds');

  branch() => Intl.message('branch');

  account() => Intl.message('account');

  String save() => Intl.message('save');

  String success() => Intl.message('success');

  finish() => Intl.message('finish');

  /// Messages
  logout() => Intl.message('logout');

  sureLogout() => Intl.message('sureLogout');

  notFound() => Intl.message('notFound');

  noData() => Intl.message('noData');

  errorOccurred() => Intl.message('errorOccurred');

  requestFailed() => Intl.message('requestFailed');

  connectionError() => Intl.message('connectionError');

  checkInternet() => Intl.message('checkInternet');

  execTimeout() => Intl.message('execTimeout');

  String pleaseEnter() => Intl.message('pleaseEnter');

  String pleaseChoose() => Intl.message('pleaseChoose');

  /// Intro
  page1Title() => Intl.message('page1Title');

  page1Text() => Intl.message('page1Text');

  page2Title() => Intl.message('page2Title');

  page2Text() => Intl.message('page2Text');

  page3Title() => Intl.message('page3Title');

  page3Text() => Intl.message('page3Text');

  page4Title() => Intl.message('page4Title');

  page4Text() => Intl.message('page4Text');

  /// Story
  String story1Title() => Intl.message('story1Title');

  String story1Text() => Intl.message('story1Text');

  String story2Title() => Intl.message('story2Title');

  String story2Text() => Intl.message('story2Text');

  String story3Title() => Intl.message('story3Title');

  String story3Text() => Intl.message('story3Text');

  /// New user
  String areYouNewUser() => Intl.message('areYouNewUser');

  String needSignUp() => Intl.message('needSignUp');

  /// Privacy policy, Term condition
  termCond() => Intl.message('termCond');

  termCondAgree() => Intl.message('termCondAgree');

  termCondTap() => Intl.message('termCondTap');

  /// Sign up
  String warning() => Intl.message('warning');

  String again() => Intl.message('again');

  String badPic() => Intl.message('badPic');

  String frontId() => Intl.message('frontId');

  String nextt() => Intl.message('nextt');

  String next() => Intl.message('next');

  String backId() => Intl.message('backId');

  String hintFrontId() => Intl.message('hintFrontId');

  String hintCamera() => Intl.message('hintCamera');

  String hintCamera2() => Intl.message('hintCamera2');

  String pleaseWait() => Intl.message('pleaseWait');

  String loading() => Intl.message('loading');

  String yourInfo() => Intl.message('yourInfo');

  String regNo() => Intl.message('regNo');

  String faceRecognition() => Intl.message('faceRecognition');

  String selfie() => Intl.message('selfie');

  String enterPhoneNumber() => Intl.message('enterPhoneNumber');

  String enterTanCode() => Intl.message('enterTanCode');

  String tanCodeHint() => Intl.message('tanCodeHint');

  String getPassword() => Intl.message('getPassword');

  String enterValidMobile() => Intl.message('enterValidMobile');

  String enterTanCodeMobile() => Intl.message('enterTanCodeMobile');

  String invalidTanCode() => Intl.message('invalidTanCode');

  String msgSentPass() => Intl.message('msgSentPass');

  String workTime() => Intl.message('workTime');

  /// Home
  home() => Intl.message('home');

  loan() => Intl.message('loan');

  netPoint() => Intl.message('netPoint');

  settings() => Intl.message('settings');

  getLoanPrivilege() => Intl.message('getLoanPrivilege');

  microLoan() => Intl.message('microLoan');

  collateralLoan() => Intl.message('collateralLoan');

  availableLoanAmount() => Intl.message('availableLoanAmount');

  loanAmount() => Intl.message('loanAmount');

  activeLoan() => Intl.message('activeLoan');

  getLoan() => Intl.message('getLoan');

  noActiveLoans() => Intl.message('noActiveLoans');

  /// Notification
  notification() => Intl.message('notification');

  notifHistory() => Intl.message('notifHistory');

  readAll() => Intl.message('readAll');

  /// Settings
  privateInfo() => Intl.message('privateInfo');

  myAcnt() => Intl.message('myAcnt');

  history() => Intl.message('history');

  msgInsertMobileEmail() => Intl.message('msgInsertMobileEmail');

  help() => Intl.message('help');

  linkFb() => Intl.message('linkFb');

  mobileOrEmail() => Intl.message('mobileOrEmail');

  backToLogin() => Intl.message('backToLogin');

  String acntDetail() => Intl.message('acntDetail');

  userGuide() => Intl.message('userGuide');

  faq() => Intl.message('faq');

  callOperator() => Intl.message('callOperator');

  webSite() => Intl.message('webSite');

  bonusPoint() => Intl.message('bonusPoint');

  deviceList() => Intl.message('deviceList');

  devices() => Intl.message('devices');

  biometric() => Intl.message('biometric');

  sureDelete() => Intl.message('sureDelete');

  search() => Intl.message('search');

  /// Profile
  relative() => Intl.message('relative');

  relativeHint() => Intl.message('relativeHint');

  relativeMobile() => Intl.message('relativeMobile');

  relativeType() => Intl.message('relativeType');

  String registerNo() => Intl.message('registerNo');

  email() => Intl.message('email');

  gender() => Intl.message('gender');

  male() => Intl.message('male');

  female() => Intl.message('female');

  martial() => Intl.message('martial');

  address() => Intl.message('address');

  socialAcnt() => Intl.message('socialAcnt');

  saveSuccess() => Intl.message('saveSuccess');

  clickFinish() => Intl.message('clickFinish');

  liveWith() => Intl.message('liveWith');

  relativeWho() => Intl.message('relativeWho');

  additionalInfo() => Intl.message('additionalInfo');

  additionalInfoHint() => Intl.message('additionalInfoHint');

  education() => Intl.message('education');

  homeType() => Intl.message('homeType');

  homeOwnership() => Intl.message('homeOwnership');

  workPlace() => Intl.message('workPlace');

  workPosition() => Intl.message('workPosition');

  countFamilyMembers() => Intl.message('countFamilyMembers');

  countFamilyMembersWithIncome() => Intl.message('countFamilyMembersWithIncome');

  salaryIncome() => Intl.message('salaryIncome');

  monthlyLnPayment() => Intl.message('monthlyLnPayment');

  String higherThan() => Intl.message('higherThan');

  /// Net point

  String netPoint2() => Intl.message('netPoint2');

  String availableScore() => Intl.message('availableScore');

  String usedScore() => Intl.message('usedScore');

  String collected() => Intl.message('collected');

  String increaseLimit() => Intl.message('increaseLimit');

  String decreaseFee() => Intl.message('decreaseFee');

  String limitHint() => Intl.message('limitHint');

  String feeHint() => Intl.message('feeHint');

  String limitAfter() => Intl.message('limitAfter');

  String earnPointWays() => Intl.message('earnPointWays');

  String watchGuidance() => Intl.message('watchGuidance');

  String inviteFriend() => Intl.message('inviteFriend');

  String punctualPayment() => Intl.message('punctualPayment');

  String used() => Intl.message('used');

  String msgIncLimit() => Intl.message('msgIncLimit');

  String msgDecFee() => Intl.message('msgDecFee');

  String currentFees() => Intl.message('currentFees');

  String feeAfterDec() => Intl.message('feeAfterDec');

  String sureUsePoint() => Intl.message('sureUsePoint');

  /// Branch
  String map() => Intl.message('map');

  String list() => Intl.message('list');

  String call() => Intl.message('call');

  String km() => Intl.message('km');

  String branchesUb() => Intl.message('branchesUb');

  String branchesCountrySide() => Intl.message('branchesCountrySide');

  /// Account
  String addAcnt() => Intl.message('addAcnt');

  String addAcntHint() => Intl.message('addAcntHint');

  String chooseBank() => Intl.message('chooseBank');

  String acntNo() => Intl.message('acntNo');

  String makeMainAcnt() => Intl.message('makeMainAcnt');

  String msgChooseBank() => Intl.message('msgChooseBank');

  String msgEnterAcntNo() => Intl.message('msgEnterAcntNo');

  String acntName() => Intl.message('acntName');

  String mainAcnt() => Intl.message('mainAcnt');

  String otherAcnt() => Intl.message('otherAcnt');

  String acnt() => Intl.message('acnt');

  /// Loan
  String loanDetail() => Intl.message('loanDetail');

  String loanStatus() => Intl.message('loanStatus');

  String paid() => Intl.message('paid');

  String lateCharge() => Intl.message('lateCharge');

  String advanceDate() => Intl.message('advanceDate');

  String remainingDays() => Intl.message('remainingDays');

  String overdue() => Intl.message('overdue');

  String nextDuePayment() => Intl.message('nextDuePayment');

  String endDate() => Intl.message('endDate');

  String thisMonthsPayment() => Intl.message('thisMonthsPayment');

  String product() => Intl.message('product');

  String excessDate() => Intl.message('excessDate');

  String increasedInterest() => Intl.message('increasedInterest');

  String status() => Intl.message('status');

  String paymentSchedule() => Intl.message('paymentSchedule');

  String extendLoan() => Intl.message('extendLoan');

  String repayLoan() => Intl.message('repayLoan');

  String noScheduleData() => Intl.message('noScheduleData');

  String extendRequest() => Intl.message('extendRequest');

  String selectExtendPeriod() => Intl.message('selectExtendPeriod');

  String day() => Intl.message('day');

  String days() => Intl.message('days');

  String reminder() => Intl.message('reminder');

  String reminderExtend() => Intl.message('reminderExtend');

  String extendDetails() => Intl.message('extendDetails');

  String extendPeriod() => Intl.message('extendPeriod');

  String repayDate() => Intl.message('repayDate');

  String loanExtensionFee() => Intl.message('loanExtensionFee');

  String princFee() => Intl.message('princFee');

  String payFee() => Intl.message('payFee');

  String loanTerm() => Intl.message('loanTerm');

  String paymentDetails() => Intl.message('paymentDetails');

  String selectToAcnt() => Intl.message('selectToAcnt');

  String totalRepayAmt() => Intl.message('totalRepayAmt');

  String loanLimit() => Intl.message('loanLimit');

  String reqAmt() => Intl.message('reqAmt');

  String term() => Intl.message('term');

  String totalRepayAmt2() => Intl.message('totalRepayAmt2');

  String receivingAccount() => Intl.message('receivingAccount');

  String loanGraph() => Intl.message('loanGraph');

  String date() => Intl.message('date');

  String totalPayment() => Intl.message('totalPayment');

  String theorBal() => Intl.message('theorBal');

  String totalLoanAmt() => Intl.message('totalLoanAmt');

  String noActiveLoan() => Intl.message('noActiveLoan');

  String daysRemaining() => Intl.message('daysRemaining');

  String daysOvertime() => Intl.message('daysOvertime');

  /// QPay
  String classs() => Intl.message('classs');

  String payEbank() => Intl.message('payEbank');

  String otherBanks() => Intl.message('otherBanks');

  String payQpay() => Intl.message('payQpay');

  String tranDesc() => Intl.message('tranDesc');

  String bankApp() => Intl.message('bankApp');

  String receiveBank() => Intl.message('receiveBank');

  String copy() => Intl.message('copy');

  String copied() => Intl.message('copied');

  String cantOpenApp() => Intl.message('cantOpenApp');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => supportedLanguagesCodes.contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => Localization.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
