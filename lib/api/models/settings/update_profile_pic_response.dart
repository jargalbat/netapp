import 'package:netware/api/models/base_response.dart';

class UpdateProfilePicResponse extends BaseResponse {
  String base64Image;

  UpdateProfilePicResponse({
    this.base64Image,
  });

  UpdateProfilePicResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    base64Image = json['str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base64Image'] = this.base64Image;

    return data;
  }
}
