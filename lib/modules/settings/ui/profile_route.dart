import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/update_profile_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/combobox/combo_bloc.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/combobox.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/settings/bloc/profile_bloc.dart';
import 'package:netware/modules/settings/bloc/profile_helper.dart';
import 'package:netware/modules/settings/ui/camera_route.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ProfileRoute extends StatefulWidget {
  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  /// UI
  final _profileKey = GlobalKey<ScaffoldState>();
  var _scrollController = ScrollController();

  /// Data
  final _profileBloc = ProfileBloc();

  /// Profile pic
  final double _profilePicSize = 130.0;

  /// Last name
  TextEditingController _lNameController = TextEditingController();
  FocusNode _lnameFocusNode = FocusNode();
  bool _isLnameValid = false;

  /// First name
  TextEditingController _fNameController = TextEditingController();
  FocusNode _fnameFocusNode;
  bool _isfNameValid = false;

  /// Mobile
  bool _isMobileValid = false;
  TextEditingController _mobileController = TextEditingController();
  String _prefixMobile = '+976';

  /// Email
  bool _isEmailValid = false;
  TextEditingController _emailController = TextEditingController();

  /// Регистрийн дугаар
  TextEditingController _regNoController = TextEditingController();
  bool _isRegNoValid = false;
  List<String> _cyrillicList;
  String _regNoFirstCharComboId = '_regNoFirstCharComboId';
  String _regNoFirstChar = '';
  String _regNoSecondCharComboId = '_regNoSecondCharComboId';
  String _regNoSecondChar = '';

  /// Хүйс
  var _genderComboBloc = ComboBloc();
  String _genderComboValue = '';

  /// Гэрлэлтийн байдал
  var _martialComboBloc = ComboBloc();
  List<ComboItem> _martialComboItemList = [];
  int _martialComboValue;

  /// Address
  bool _isAddressValid = false;
  TextEditingController _addressController = TextEditingController();

  /// Сошиал хаяг
  TextEditingController _fbController = TextEditingController();
  bool _isFbValid = false;

  /// Button save
  bool _enabledBtnSave = true;

  @override
  void initState() {
    _profileBloc.add(GetMartialList());
    _profileBloc.add(GetProfile());

    _initControls();

    _initData();

    super.initState();
  }

  @override
  void dispose() {
    _lNameController.dispose();
    _fNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _regNoController.dispose();
    _genderComboBloc?.close();
    _genderComboBloc = null;
    _profileBloc.close();
    _martialComboBloc?.close();
    _martialComboBloc = null;
    _addressController.dispose();
    _fbController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => _profileBloc,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: _blocListener,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ProfileState state) {
    if (state is GetProfileSuccess) {
      _setData();
    } else if (state is UpdateProfileFailed) {
      showSnackBar(key: _profileKey, text: state.text);
      _enabledBtnSave = true;
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _profileKey, text: state.text);
    } else if (state is GetMartialListSuccess) {
      _martialComboItemList = DictionaryManager.getComboItemList(state.martialList);
      _martialComboValue = globals.user?.maritalId;
      if (_martialComboItemList.isNotEmpty) {
        String martialText = ComboHelper.getComboTextByValue(_martialComboItemList, Func.toStr(_martialComboValue));
        _martialComboBloc.add(SelectItemEvent(text: martialText));
      }
    } else if (state is UpdateProfileSuccess) {
      showCustomDialog(
        context: context,
        img: Image.asset(
          AssetName.success_blue,
          height: 74.0,
          colorBlendMode: BlendMode.modulate,
        ),
        title: globals.text.success(),
//        body: globals.text.clickFinish(),
        bodyHeight: 100.0,
        btnText: 'Ok',
        onPressedBtn: () {
          Navigator.pop(context);
        },
      );
      _enabledBtnSave = true;
    } else if (state is UploadProfilePictureSuccess) {
      globals.user.imgAsBase64 = state.base64Image;
    } else if (state is UploadProfilePictureFailed) {
      showSnackBar(key: _profileKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, ProfileState state) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: BlurLoadingContainer(
        loading: state is ProfileLoading,
        child: Scaffold(
          key: _profileKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            context: context,
            onPressed: _onBackPressed,
            brightness: Brightness.light,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Хувийн мэдээлэл
                  lbl(
                    globals.text.privateInfo(),
                    style: lblStyle.Headline4,
                    margin: EdgeInsets.only(left: AppHelper.margin),
                  ),

                  SizedBox(height: 20.0),

                  /// Profile pic
                  _profilePic(),

                  /// Овог
                  _txtLastName(),

                  /// Нэр
                  _txtFirstName(),

                  /// Утасны дугаар
                  _txtMobile(),

                  /// Цахим хаяг
                  _txtEmail(),

                  /// Регистрийн дугаар
                  Row(
                    children: <Widget>[
                      /// Label
                      lbl(
                        globals.text.registerNo(),
                        fontSize: 12.0,
                        margin: EdgeInsets.fromLTRB(AppHelper.margin, 10.0, 0.0, 0.0),
                      ),

                      /// Label validation
                      lbl(
                        _isRegNoValid ? '' : AppHelper.symbolValid,
                        color: AppColors.lblRed,
                        fontSize: 12.0,
                        margin: EdgeInsets.fromLTRB(0.0, 20.0, AppHelper.margin, 0.0),
                      ),
                    ],
                  ),

                  _registerNoWidget(),

                  /// Хүйс
                  _genderCombo(),

                  /// Гэрлэлтийн байдал
                  _maritalCombo(),

                  /// Хаяг
                  _txtAddress(),

//                  /// Сошиал хаяг
//                  _txtFb(),

                  SizedBox(height: 30.0),

                  /// Хадгалах
                  _btnSave(),

                  SizedBox(height: AppHelper.marginBottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _initControls() {
    _lNameController.addListener(() {
      setState(() => _isLnameValid = _lNameController.text.length > 0);
    });

    _fNameController.addListener(() {
      setState(() => _isfNameValid = _fNameController.text.length > 0);
    });

    _mobileController.addListener(() {
      setState(() => _isMobileValid = _mobileController.text.length == 8);
    });

    _emailController.addListener(() {
      setState(() {
        if (_emailController.text.length > 0 && Func.validEmail(_emailController.text)) {
          _isEmailValid = true;
        } else {
          _isEmailValid = false;
        }
      });
    });

    _regNoController.addListener(() {
      setState(() => _validateRegNo());
    });

    _addressController.addListener(() {
      setState(() => _isAddressValid = _addressController.text.length > 0);
    });

    _fbController.addListener(() {
      setState(() => _isFbValid = _fbController.text.length > 0);
    });
  }

  void _initData() {
    _lNameController.text = globals.user?.lastName ?? '';
    _fNameController.text = globals.user?.firstName ?? '';
    _mobileController.text = globals.user?.mobileNo ?? '';
    _emailController.text = globals.user?.email ?? '';

    // Регистр
    _cyrillicList = ProfileHelper.getCyrillicList();
    _regNoFirstChar = ProfileHelper.getRegNoFirstChar(globals.user.regNo);
    _regNoSecondChar = ProfileHelper.getRegNoSecondChar(globals.user.regNo);
    _regNoController.text = ProfileHelper.getRegNoNumbers(globals.user.regNo);

    // Хаяг
    _addressController.text = globals.user?.addrDetail;

    _setData();
  }

  void _setData() {
    if (Func.isEmpty(globals.user?.sex) || globals.user?.maritalId == null || Func.isEmpty(globals.user.addrDetail)) {
      // Мэдээлэл дутуу байвал серверээс татаж авна
      return;
    }
    // Хүйс
    _genderComboValue = globals.user?.sex;
    String genderText = ComboHelper.getComboTextByValue(ProfileHelper.genderComboItemList, _genderComboValue);
    _genderComboBloc.add(SelectItemEvent(text: genderText));

    // Гэрлэлтийн байдал
    _martialComboValue = globals.user?.maritalId;
    if (_martialComboItemList.isNotEmpty && _martialComboValue != null) {
      String martialText = ComboHelper.getComboTextByValue(_martialComboItemList, Func.toStr(_martialComboValue));
      _martialComboBloc.add(SelectItemEvent2(text: martialText));
    }

    _addressController.text = globals.user.addrDetail ?? '';
    _fbController.text = globals.user.fbName ?? '';
  }

  _profilePic() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        /// Place holder

        Align(
          alignment: Alignment.center,
          child: ClipOval(
            child: Container(
              color: AppColors.iconRegentGrey,
              child: Func.isNotEmpty(globals.user?.imgAsBase64)
                  ? Image.memory(
                      base64Decode(globals.user?.imgAsBase64),
                      fit: BoxFit.cover,
                      width: _profilePicSize,
                      height: _profilePicSize,
                    )
                  : Image.asset(
                      AssetName.profile_placeholder3,
                      width: _profilePicSize,
                      height: _profilePicSize,
                    ),
            ),
          ),
        ),

        /// Camera button
        Container(
          height: _profilePicSize,
          width: _profilePicSize,
          alignment: Alignment.bottomRight,
          child: Container(
            height: 44.0,
            width: 44.0,
            child: FittedBox(
              child: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () {
                    Navigator.push(context, FadeRouteBuilder(route: CameraRoute(
                      callBack: (file) {
                        _profileBloc.add(UploadProfilePicture(file: file));
                      },
                    )));
                  }),
            ),
          ),
        ),
      ],
    );
  }

  _txtLastName() {
    return txt(
      labelText: globals.text.lastName(),
      context: context,
      margin: EdgeInsets.only(top: 0.0, right: AppHelper.margin, left: AppHelper.margin),
      controller: _lNameController,
      focusNode: _lnameFocusNode,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      isValidated: _isLnameValid,
    );
  }

  _txtFirstName() {
    return txt(
      labelText: globals.text.firstName(),
      context: context,
      margin: EdgeInsets.only(top: 10.0, right: AppHelper.margin, left: AppHelper.margin),
      controller: _fNameController,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      isValidated: _isfNameValid,
    );
  }

  _txtMobile() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 10.0, right: AppHelper.margin, left: AppHelper.margin),
      labelText: globals.text.mobile(),
      controller: _mobileController,
      maxLength: 8,
      textInputType: TextInputType.number,
      prefixText: (_prefixMobile),
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      isValidated: _isMobileValid,
    );
  }

  _txtEmail() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 10.0, right: AppHelper.margin, left: AppHelper.margin),
      labelText: globals.text.email(),
      controller: _emailController,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      isValidated: _isEmailValid,
    );
  }

  _registerNoWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(AppHelper.margin, 10.0, AppHelper.margin, 0.0),
      child: Row(
        children: <Widget>[
          /// First char
          GestureDetector(
            onTap: () {
              _showRegNoComboList(_regNoFirstCharComboId);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppHelper.borderRadiusBtn),
                ),
                color: AppColors.bgWhite,
              ),
              height: AppHelper.textBoxHeight,
              width: AppHelper.textBoxHeight,
              child: Center(child: lbl(_regNoFirstChar, alignment: Alignment.center)),
            ),
          ),

          SizedBox(width: 10.0),

          /// Second char
          GestureDetector(
            onTap: () {
              _showRegNoComboList(_regNoSecondCharComboId);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppHelper.borderRadiusBtn),
                  ),
                  color: AppColors.bgWhite),
              height: AppHelper.textBoxHeight,
              width: AppHelper.textBoxHeight,
              child: Center(
                  child: lbl(
                _regNoSecondChar,
                alignment: Alignment.center,
              )),
            ),
          ),

          SizedBox(width: 10.0),

          /// Numbers
          Expanded(
            child: txt(
              context: context,
//              margin: EdgeInsets.only(right: AppHelper.margin),
              controller: _regNoController,
              maxLength: 13,
              textInputType: TextInputType.number,
              textColor: AppColors.lblDark,
              labelFontWeight: FontWeight.normal,
              bgColor: AppColors.txtBgGrey,
              isValidated: !_isRegNoValid,
            ),
          ),
        ],
      ),
    );
  }

  void _showRegNoComboList(String comboId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _cyrillicList.length,
          itemBuilder: (context, i) {
            return _regNoComboListItem(comboId, _cyrillicList[i]);
          },
        );
      },
    );
  }

  Widget _regNoComboListItem(String comboId, String str) {
    return ListTile(
      title: lbl(str),
      onTap: () {
        setState(() {
          if (comboId == _regNoFirstCharComboId) {
            _regNoFirstChar = str;
          } else {
            _regNoSecondChar = str;
          }
        });

        Navigator.pop(context);
      },
    );
  }

  void _validateRegNo() {
    if (Func.isEmpty(_regNoFirstChar) || Func.isEmpty(_regNoSecondChar)) {
      _isRegNoValid = false;
      return;
    }

    if (_regNoController.text.isEmpty) {
      _isRegNoValid = false;
      return;
    }

    _isRegNoValid = true;
  }

  Widget _genderCombo() {
    return CustomCombo(
      comboBloc: _genderComboBloc,
      label: globals.text.gender(),
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 10.0, AppHelper.margin, 0.0),
      list: ProfileHelper.genderComboItemList,
//      initialText: ProfileHelper.genderComboItemList[0].txt,
      width: 200.0,
      onItemSelected: (value) {
        _genderComboValue = value;
      },
    );
  }

  Widget _maritalCombo() {
    return _martialComboItemList.isNotEmpty
        ? CustomCombo(
            comboBloc: _martialComboBloc,
            label: globals.text.martial(),
            margin: EdgeInsets.fromLTRB(AppHelper.margin, 10.0, AppHelper.margin, 0.0),
            list: _martialComboItemList,
//            initialText: _martialComboItemList[0].txt,
            width: 200.0,
            onItemSelected: (value) {
              DictionaryData data = value;
              try {
                _martialComboValue = int.parse(data.val);
              } catch (e) {
                showSnackBar(key: _profileKey, text: globals.text.errorOccurred());
              }
            },
          )
        : Container();
  }

  _txtAddress() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 10.0, right: AppHelper.margin, left: AppHelper.margin),
      labelText: globals.text.address(),
      controller: _addressController,
      maxLength: 100,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      isValidated: _isAddressValid,
    );
  }

  _txtFb() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: AppHelper.margin, left: AppHelper.margin),
      labelText: globals.text.socialAcnt(),
      controller: _fbController,
      maxLength: 100,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      enabled: false,
    );
  }

  void checkPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]);
    print(permissions);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      FocusScope.of(context).requestFocus(new FocusNode());

//      Navigator.of(context).push(
//        new PageRouteBuilder(
//          pageBuilder: (BuildContext context, _, __) {
//            return new LocationScreen(callBack: _callBackLocation);
////            return new MapSample();
//          },
//          transitionsBuilder:
//              (_, Animation<double> animation, __, Widget child) {
//            return new FadeTransition(opacity: animation, child: child);
//          },
//        ),
//      );
    }
  }

//  _callBackLocation(String location) {
//    _addressController.text = location;
//  }
//
//  _onPressedBtnCamera() {}

  _btnSave() {
    return CustomButton(
      text: Func.toStr(globals.text.save()),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _enabledBtnSave ? _onPressedBtnSave : null,
    );
  }

  _onPressedBtnSave() {
    try {
//      BlocProvider.of<AppBloc>(context).add(LogoutEvent());

      if (!_validation()) return;

      var req = UpdateProfileRequest()
        ..userId = globals.user.userId
        ..custCode = globals.user.custCode
        ..loginName = globals.user.loginName
        ..lastName = _lNameController.text
        ..firstName = _fNameController.text
        ..mobileNo = _mobileController.text
        ..email = _emailController.text
        ..regNo = _regNoFirstChar + _regNoSecondChar + _regNoController.text
        ..sex = _genderComboValue
        ..maritalId = _martialComboValue
        ..addrDetail = _addressController.text;

      _enabledBtnSave = false;

      _profileBloc.add(UpdateProfile(request: req));
    } catch (e) {
      print(e);
    }
  }

  bool _validation() {
    if (!_isLnameValid) {
      showSnackBar(key: _profileKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.lastName()));
      return false;
    }

    if (!_isfNameValid) {
      showSnackBar(key: _profileKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.firstName()));
      return false;
    }

    if (!_isMobileValid) {
      showSnackBar(key: _profileKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.mobile()));
      return false;
    }

    if (!_isEmailValid) {
      showSnackBar(key: _profileKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.email()));
      return false;
    }

    if (!_isRegNoValid) {
      showSnackBar(key: _profileKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.registerNo()));
      return false;
    }

    if (!_isAddressValid) {
      showSnackBar(key: _profileKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.address()));
      return false;
    }

    return true;
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}

/// Major
//  bool _isMajorValid = false;
//  TextEditingController _majorController = TextEditingController();
//  List<String> _majorList;

//    _majorList = new List<String>();
//    _majorList.add('Уул уурхай');
//    _majorList.add('Худалдаа');
//    _majorList.add('Банк санхүү');
//    _majorList.add('Даатгал');
//    _majorList.add('Үйлчилгээ');
//    _majorList.add('ТББ');
//    _majorList.add('ОУБ');
//
//    _majorController.addListener(() {
//      if (_majorController.text.length > 0) {
//        setState(() {
//          _isMajorValid = true;
//        });
//      } else {
//        setState(() {
//          _isMajorValid = false;
//        });
//      }
//    });

//  _txtMajor() {
//    return txt(
//      context: context,
//      margin: EdgeInsets.only(top: 20.0, right: AppHelper.margin, left: AppHelper.margin),
//      labelText: 'Мэргэжил',
//      controller: _majorController,
//      maxLength: 30,
//      textInputType: TextInputType.text,
//      textColor: AppColors.lblDark,
//      labelFontWeight: FontWeight.normal,
//      bgColor: AppColors.txtBgGrey,
//      suffixIcon: !_isMajorValid
//          ? IconButton(
//              icon: Icon(
//                Icons.error_outline,
//                color: AppColors.iconScarletRed,
//              ),
//              onPressed: () async {
//                FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
//
//                showComboPicker(
//                  context: context,
//                  list: _majorList,
//                  onItemPicked: (value) {
//                    setState(() {
//                      _majorController.text = value ?? '';
//                    });
//                  },
//                );
//              },
//            )
//          : null,
//    );
//  }
