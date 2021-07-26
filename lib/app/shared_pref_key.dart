class SharedPrefKey {
  /// Global
  static const String Theme = "Theme";
  static const String Locale = "Locale";
  static const String TestBaseUrl = "TestBaseUrl"; // Зөвхөн test хийхэд зориулсан connection url
  static const String SecureMode = "SecureMode"; // Дансны үлдэгдэл нууцлах эсэх
  static const String IntroLimit = "IntroLimit"; // Intro харуулсан тоо
  static const String PrivacyPolicy = "PrivacyPolicy"; // Privacy policy зөвшөөрсөн эсэх
  static const String PushNotifToken = "PushNotifToken"; // Google firebase push notification token

  /// Sign up
  static const String SignUpStepNo = "SignUpStepNo";
  static const String SignUpUserKey = "SignUpUserKey";

  /// Login
  static const String RememberMe = "RememberMe";
  static const String LoginName = "LoginName";
  static const String Password = "Password";
}
