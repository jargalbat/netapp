import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/customer/update_cust_addition_request.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/simple_combo_text.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/home/ui/home_route.dart';
import 'package:netware/modules/settings/bloc/additional_profile_bloc.dart';

/// Нэмэлт мэдээлэл
class AdditionalProfileRoute extends StatefulWidget {
  @override
  _AdditionalProfileRouteState createState() => _AdditionalProfileRouteState();
}

class _AdditionalProfileRouteState extends State<AdditionalProfileRoute> {
  /// UI
  var _apKey = GlobalKey<ScaffoldState>();

  /// Data
  var _additionalProfileBloc = AdditionalProfileBloc();

  /// Боловсрол
  List<ComboItem> _eduList = [];
  String _selectedEdu;

  /// Орон сууцны төрөл
  List<ComboItem> _homeTypeList = [];
  String _selectedHomeType;

  /// Хаягийн эзэмшлийн байдал
  List<ComboItem> _homeOwnershipList = [];
  String _selectedHomeOwnership;

  /// Ажлын газар
  List<ComboItem> _workPlaceList = [];
  String _selectedEmploymentType;

  /// Албан тушаал
  List<ComboItem> _workPositionList = [];
  String _selectedWorkPosition;

  /// Ам бүл
  List<ComboItem> _familyMembersCountList = [];
  int _selectedFamilyMemberCount;

  /// Өрхийн орлоготой гишүүүдийн тоо
  List<ComboItem> _familyMembersCountWithIncomeList = [];
  int _selectedFamilyMemberCountWithIncome;

  /// Цалингийн орлого
  TextEditingController _salaryIncomeController = TextEditingController();
  bool _isSalaryIncomeValid = false;

  /// Сард төлдөг зээл
  TextEditingController _monthlyLnPaymentController = TextEditingController();
  bool _isMonthlyLnPaymentValid = false;

  /// Цахим хаяг
  TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  /// Button дуусгах
  bool _isEnabledBtnFinish = false;

  @override
  void initState() {
    _additionalProfileBloc.add(GetDictEdu());
    _additionalProfileBloc.add(GetDictHomeType());
    _additionalProfileBloc.add(GetDictHomeOwnership());
    _additionalProfileBloc.add(GetDictWorkPlace());
    _additionalProfileBloc.add(GetDictWorkPosition());
    _additionalProfileBloc.add(GetNumbersList());

    _salaryIncomeController.addListener(() {
      setState(() {
        _isSalaryIncomeValid = _salaryIncomeController.text.isNotEmpty;
        _checkEnabledBtnFinish();
      });
    });

    _monthlyLnPaymentController.addListener(() {
      setState(() {
        _isMonthlyLnPaymentValid = _monthlyLnPaymentController.text.isNotEmpty;
        _checkEnabledBtnFinish();
      });
    });

    _emailController.addListener(() {
      setState(() {
        setState(() {
          if (_emailController.text.length > 0 &&
              Func.validEmail(_emailController.text)) {
            _isEmailValid = true;
          } else {
            _isEmailValid = false;
          }
        });
        _checkEnabledBtnFinish();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _additionalProfileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdditionalProfileBloc>(
      create: (context) => _additionalProfileBloc,
      child: BlocListener<AdditionalProfileBloc, AdditionalProfileState>(
        listener: _blocListener,
        child: BlocBuilder<AdditionalProfileBloc, AdditionalProfileState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AdditionalProfileState state) {
    if (state is GetDictEduSuccess) {
      _eduList = state.comboList;
    } else if (state is GetDictHomeTypeSuccess) {
      _homeTypeList = state.comboList;
    } else if (state is GetDictHomeOwnershipSuccess) {
      _homeOwnershipList = state.comboList;
    } else if (state is GetDictWorkPlaceSuccess) {
      _workPlaceList = state.comboList;
    } else if (state is GetDictWorkPositionSuccess) {
      _workPositionList = state.comboList;
    } else if (state is GetNumbersListSuccess) {
      _familyMembersCountList = state.comboList;
      _familyMembersCountWithIncomeList = state.comboList;
    } else if (state is InsertAdditionalProfileSuccess) {
      Navigator.pushReplacement(context, FadeRouteBuilder(route: HomeRoute()));
    } else if (state is PaShowSnackBar) {
      showSnackBar(key: _apKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, AdditionalProfileState state) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            Navigator.pop(context);
          },
//          hasBackArrow: true,
        ),
        backgroundColor: AppColors.bgGrey,
        key: _apKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .requestFocus(new FocusNode()); // Keyboard хаах
          },
          child: LoadingContainer(
            loading: state is ProfileAdditionalLoading,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    right: AppHelper.margin, left: AppHelper.margin),
                child: Column(
                  children: <Widget>[
                    /// Нэмэлт мэдээлэл
                    lbl(globals.text.additionalInfo(),
                        style: lblStyle.Headline4, color: AppColors.lblBlue),

                    SizedBox(height: AppHelper.margin),

                    /// Та доорх мэдээллүүдийг үнэн зөв бөглөнө үү. Баярлалаа.
                    lbl(globals.text.additionalInfoHint(),
                        style: lblStyle.Medium, maxLines: 3),

                    SizedBox(height: 20.0),

                    CustomCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          /// Хувийн мэдээлэл
                          lbl(globals.text.privateInfo(),
                              style: lblStyle.Medium, color: AppColors.lblGrey),

                          SizedBox(height: 10.0),

                          /// Хөндлөн зураас
                          Divider(color: AppColors.lineGrey),

                          SizedBox(height: 10.0),

                          /// Боловсрол
                          _eduCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Орон сууцны төрөл
                          _homeTypeCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Хаягийн эзэмшлийн байдал
                          _homeOwnershipCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Ажлын газар
                          _workPlaceCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Албан тушаал
                          _workPositionCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Ам бүл
                          _familyMembersCountCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Өрхийн орлоготой гишүүүдийн тоо
                          _familyMembersCountWithIncomeCombo(),

                          SizedBox(height: AppHelper.margin),

                          /// Цалингийн орлого
                          _txtSalaryIncome(),

                          SizedBox(height: AppHelper.margin),

                          /// Сард төлдөг зээл
                          _txtMonthlyLnPayment(),

                          SizedBox(height: AppHelper.margin),

                          /// Цахим хаяг
                          _txtEmail(),

                          SizedBox(height: AppHelper.margin),

                          /// Button Баталгаажуулах
                          _btnFinish(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _eduCombo() {
    return SimpleComboText(
      label: '${globals.text.education()}:',
      list: _eduList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedEdu = (value as DictionaryData).val;
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _homeTypeCombo() {
    return SimpleComboText(
      label: '${globals.text.homeType()}:',
      list: _homeTypeList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedHomeType = (value as DictionaryData).val;
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _homeOwnershipCombo() {
    return SimpleComboText(
      label: '${globals.text.homeOwnership()}:',
      list: _homeOwnershipList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedHomeOwnership = (value as DictionaryData).val;
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _workPlaceCombo() {
    return SimpleComboText(
      label: '${globals.text.workPlace()}:',
      list: _workPlaceList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedEmploymentType = (value as DictionaryData).val;
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _workPositionCombo() {
    return SimpleComboText(
      label: '${globals.text.workPosition()}:',
      list: _workPositionList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedWorkPosition = (value as DictionaryData).val;
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _familyMembersCountCombo() {
    return SimpleComboText(
      label: '${globals.text.countFamilyMembers()}:',
      list: _familyMembersCountList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedFamilyMemberCount = (value as int);
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _familyMembersCountWithIncomeCombo() {
    return SimpleComboText(
      label: '${globals.text.countFamilyMembersWithIncome()}:',
      list: _familyMembersCountWithIncomeList,
      bgColor: AppColors.bgGrey,
      onItemSelected: (value) {
        _selectedFamilyMemberCountWithIncome = (value as int);
        _checkEnabledBtnFinish();
      },
    );
  }

  Widget _txtSalaryIncome() {
    return txtAmt(
      context: context,
      labelText: globals.text.salaryIncome(),
      controller: _salaryIncomeController,
      maxLength: 30,
      textInputType: TextInputType.number,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.bgGrey,
      isValidated: _isSalaryIncomeValid,
    );
  }

  Widget _txtMonthlyLnPayment() {
    return txtAmt(
      context: context,
      labelText: globals.text.monthlyLnPayment(),
      controller: _monthlyLnPaymentController,
      maxLength: 30,
      textInputType: TextInputType.number,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.bgGrey,
      isValidated: _isMonthlyLnPaymentValid,
    );
  }

  Widget _txtEmail() {
    return txt(
      context: context,
      labelText: globals.text.email(),
      controller: _emailController,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.bgGrey,
      isValidated: _isEmailValid,
    );
  }

  Widget _btnFinish() {
    return CustomButton(
      text: Func.toStr(globals.text.finish()),
      context: context,
      margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _isEnabledBtnFinish ? _onPressedBtnFinish : null,
    );
  }

  void _checkEnabledBtnFinish() {
    bool result = false;

    if (_selectedEdu != null &&
        _selectedHomeType != null &&
        _selectedHomeOwnership != null &&
        _selectedEmploymentType != null &&
        _selectedWorkPosition != null &&
        _salaryIncomeController.text.isNotEmpty &&
        _monthlyLnPaymentController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      result = true;
    } else {
      result = false;
    }

    setState(() {
      _isEnabledBtnFinish = result;
    });
  }

  void _onPressedBtnFinish() {
    var request = UpdateCustAdditionRequest()
      ..educationLevel = _selectedEdu // Боловсрол
      ..houseType = _selectedHomeType // Орон сууцны төрөл
      ..addrType = _selectedHomeOwnership // Хаягийн эзэмшлийн байдал
      ..employmentType = _selectedEmploymentType // Ажлын газар
      ..positionCode = _selectedWorkPosition // Албан тушаал
      ..familyMemberCount = _selectedFamilyMemberCount // Ам бүл
      ..earnFamMemberCount =
          _selectedFamilyMemberCountWithIncome // Өрхийн орлоготой гишүүүдийн тоо
      ..avgSalary = Func.toInt(_salaryIncomeController.text) // Цалингийн орлого
      ..monthlyPayLoan =
          Func.toInt(_monthlyLnPaymentController.text) // Сард төлдөг зээл
      ..email = _emailController.text; // Цахим хаяг

    _additionalProfileBloc.add(InsertAdditionalProfile(request: request));
  }
}
