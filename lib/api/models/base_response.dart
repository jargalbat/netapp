class BaseResponse {
  int resultCode;
  String resultDesc;

  BaseResponse([
    this.resultCode,
    this.resultDesc,
  ]);

  BaseResponse.fromJson(Map<String, dynamic> json)
      : resultCode = json['resultCode'],
        resultDesc = json['resultDesc'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;

    return data;
  }

  static Map<String, dynamic> json([int resultCode, String resultDesc]) {
    return BaseResponse(resultCode, resultDesc).toJson();
  }

  @override
  String toString() {
    return '''BaseResponse {
      resultCode: $resultCode,    
      resultDesc: $resultDesc,       
    }''';
  }
}
