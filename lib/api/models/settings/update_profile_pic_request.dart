import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class UpdateProfilePicRequest extends BaseRequest {
  String imgPath;

  UpdateProfilePicRequest({
    this.imgPath,
  }) {
    this.func = Operation.updateProfilePic;
  }

  UpdateProfilePicRequest.fromJson(Map<String, dynamic> json) {
    imgPath = json['imgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgPath'] = this.imgPath;

    base(data);

    return data;
  }
}
