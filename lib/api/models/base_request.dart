class BaseRequest {
  int _func;

  int get func {
    return _func;
  }

  set func(int func) {
    this._func = func;
  }

  BaseRequest();

  ///
  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    return data;
  }

  void base(Map<String, dynamic> data) {
    data['func'] = this.func;
  }
}

//class BaseRequest {
//  int _func;
//
//  int get func {
//    return _func;
//  }
//
//  set func(int func) {
//    this._func = func;
//  }
//
//  Map<String, dynamic> toJson() {
//
//  };
//
//  void base(Map<String, dynamic> data) {
//    data['func'] = this.func;
//  }
//}

///
