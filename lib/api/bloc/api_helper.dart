class ApiHelper {
  /// URI = scheme:[//authority]path[?query][#fragment]

  /// Base url
  static String baseUrl = "http://202.131.251.211:7007"; // Prod //99111199 12345a, 99073149 12345a
// static String baseUrl = "http://35.223.226.253:9099"; // Test online //95688910 - 123qwe
// static String baseUrl = "http://192.168.1.212:7007"; // NC local //99073149 - 12345a
// static String baseUrl = "http://10.0.0.117:7007"; // KHAI local
// static String baseUrl = "http://192.168.137.198:7007"; // Doska

// static String baseUrl = "http://35.226.65.154:9099";
// static String baseUrl = "http://35.226.65.154:9099";
// static String baseUrl = "http://192.168.71.77:9099";
// static String baseUrl = "http://192.168.1.212:9099";
// static String baseUrl = "http://192.168.1.212:6162";
//  static String baseUrl = "http://192.168.1.212:7007"; // test
//  static String baseUrl = "http://192.168.30.51:7007"; // test 2

  /// Url paths
  static const String mainPath = '/mobilemain/gate';
  static const String fileUploadPath = '/mobilemain/upload';
}

class ResponseCode {
  /// 1xx Informational
  static const Continue = 100;

  /// 2xx Success
  static const OK = 200; // Request is successfully completed.

  /// 3xx Redirection
  static const MultipleChoices = 300;

  /// 4xx Client error
  static const RequestFailed = 4;
  static const BadRequest = 400; // No internet
  static const Unauthorized = 401; // We could not recognize you.
  static const Forbidden = 403; // Access to the requested resource or action is forbidden.
  static const NotFound = 404; // The requested resource could not be found.
  static const RequestTimeout = 408;

  /// 5xx Server error
  static const InternalServerError = 500; // We had a problem with our server. Try again later.
  static const ServiceUnavailable = 503; // We're temporarily offline for maintenance. Please try again later.

  /// Business response
  static const Success = 0;
  static const Failed = 1;
  static const SessionExpired = 91001013; // Нэвтэрнэ үү
  static const LoanInfoFailed = 92010114;
}
