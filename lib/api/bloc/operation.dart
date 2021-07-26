import 'package:netware/app/utils/logger.dart';

class Operation {
  static final logger = Logger('Const');

  /// GLOBAL
  static const int getDictionaryData = 10000010; // Dictionary-ийн утга авах
  static const int getDictionaryListData = 10000011; // Олон dictionary-ийн утга авах
  static const int getDictionaryByFilter = 10000012; // Dictionary-ийн утгыг шүүлттэй авах
  static const int termCond = 10000999; // Үйлчилгээний нөхцөл авах
  static const int getBranches4Mobile = 10000800; // Салбарын жагсаалт авах
  static const int getDataVers = 10000810; // Өгөгдлийн хувилбарын жагсаалт авах
  static const int detailDataVer = 10000811; // Өгөгдлийн хувилбарын мэдээлэл авах

  /// SIGN UP
  static const int sign_up_upload = 123456000; // Зураг оруулах
  static const int stepID = 10012010; // Иргэний үнэмлэх уншуулах
  static const int stepConfirmID = 10012011; // Хувь хүний мэдээлэл өөрчилж хадгалах
  static const int stepAddress = 10012012; // Иргэний үнэмлэхийн ар талыг уншуулах
  static const int stepSelfie = 10012013; // Selfie зурагтай харьцуулах
  static const int stepSendTAN = 10012014; // ТАН код авах
  static const int stepVerifyTAN = 10012015; // ТАН баталгаажуулах

  /// LOGIN
  static const int login = 10011000; // Нэвтрэх
  static const int logout = 10011001; // Системээс гарах

  /// PASSWORD
  static const int changePassword = 10011003; // Нууц үг солих
  static const int resetPassword = 10011004; // Нууц үг сэргээх

  /// SETTINGS
  static const int selectUserDevice = 10011010; // Тогтмол хандах төхөөрөмжийн жагсаалт авах
  static const int verifyUserDevice = 10011011; // Тогтмол хандах төхөөрөмж баталгаажуулах
  static const int updateUserDevice = 10011012; // Тогтмол хандах төхөөрөмжийн тохиргоо өөрчлөх
  static const int deleteUserDevice = 10011013; // Тогтмол хандах төхөөрөмж устгах
  static const int detailUserDevice = 10011014; // Тогтмол хандах төхөөрөмжийн дэлгэрэнгүй мэдээлэл авах
  static const int getOperatorInfo = 10011030; // Операторын мэдээлэл авах
  static const int updateBiometric = 10011040; // Биометр өөрчлөх

  /// PROFILE
  static const int getProfile = 10011020; // Өөрийн профайлын мэдээлэл авах
  static const int updateProfile = 10011021; // Профайлаа өөрчлөх
  static const int bindFb = 20000100; // FB холбох
  static const int unbindFb = 20000101; // FB салгах
  static const int selectRelative = 20000120; // Холбоотой хүмүүсийн жагсаалт авах
  static const int insertRelative = 20000121; // Холбоотой хүн бүртгэх
  static const int updateRelative = 20000122; // Холбоотой хүний мэдээлэл засах
  static const int deleteRelative = 20000123; // Холбоотой хүнийн бүртгэл хасах
  static const int detailRelative = 20000124; // Холбоотой хүний дэлгэрэнгүй харах
  static const int updateCustAddition = 20000131; // Хувийн нэмэлт өөрчлөх
  static const int updateProfilePic = 10011022; // Профайл зургаа өөрчлөх	 [{"imgPath": "img path"}]

  /// ACCOUNT

  static const int selectBankAcnt = 20000110; // Банкны дансны жагсаалт авах
  static const int insertBankAcnt = 20000111; // Банкны данс нэмэх
  static const int updateBankAcnt = 20000112; // Банкны данс засах
  static const int deleteBankAcnt = 20000113; // Банкны данс устгах
  static const int detailBankAcnt = 20000114; // Банкны дансны дэлгэрэнгүй авах

  /// LOAN
  static const int getLoanList = 20100700; // Зээлийн хүсэлт, дансны жагсаалт авах
  static const int getLoanAcntsOffline = 20100710; // Барьцаат зээлийн дансны жагсаалт авах

  static const int getAcntDetail = 20100704; // Онлайн дансны дэлгэрэнгүй авах
  static const int getLoanAcntOfflineInfo = 20100714; // Барьцаат зээлийн дансны дэлгэрэнгүй мэдээлэл авах

  static const int loanProd = 20100500; // Зээлийн бүтээгдэхүүний мэдээлэл авах
  static const int getLimitAndScore = 20100600; // Харилцагчийн зээлийн лимит, онооны мэдээлэл авах
  static const int createLoanRequest = 20100610; // Зээлийн хүсэлт гаргах
  static const int cancelLoanRequest = 20100611; // Зээлийн хүсэлт цуцлах

  /// LOAN PAYMENT
  static const int getExtendInfo = 20100705; // Зээл сунгалтын мэдээлэл авах
  static const int getPayInfoOnline = 20100706; // Онлайн зээл төлөлтийн мэдээлэл
  static const int getPayInfoOffline = 20100715; // Оффлайн зээл төлөх мэдээлэл авах

  /// NET POINT
  static const int useBonusLimit = 20100620; // Бонус оноог зээлийн лимит өсгөхөд ашиглах
  static const int useBonusFee = 20100621; // Бонус оноог зээлийн шимтгэл бууруулахад ашиглах

  /// TRANSACTION
  static const int createQpayQrCode = 20100800; // QPay qr code generate хийх

  /// Notification
  static const int getNotifications = 20100200; // Мэдэгдлийн жагсаалт авах
  static const int readNotifications = 20100201; // Мэдэгдэл унших
}
