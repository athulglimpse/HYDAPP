import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/dialog/contry_dialog.dart';
import '../../common/dialog/cupertino_picker.dart';
import '../../common/dialog/marital_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_input_field.dart';
import '../../common/widget/my_text_view.dart';
import '../../common/widget/pincode/my_pin_theme.dart';
import '../../common/widget/pincode/pin_code.dart';
import '../../data/model/app_config.dart';
import '../../data/model/country.dart';
import '../../data/model/social_login_data.dart';
import '../../utils/app_const.dart';
import '../../utils/date_util.dart';
import '../../utils/my_custom_route.dart';
import '../../utils/navigate_util.dart';
import '../../utils/string_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../congratulation_register/congratulation_regiter_page.dart';
import '../login/login_page.dart';
import '../main/main_page.dart';
import '../personalization/personalization_page.dart';
import '../verifycode/verify_code_page.dart';
import 'bloc/register_bloc.dart';
import 'component/date_time_form_field.dart';
import 'component/phone_number_form_field.dart';
import 'util/register_util.dart';

class RegisterPage extends BaseWidget {
  static const routeName = 'RegisterPage';
  final SocialLoginData socialLoginData;
  final RegisterEnum registerEnum;

  RegisterPage({this.registerEnum = RegisterEnum.EMAIL, this.socialLoginData});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage> {
  final FocusNode _focusFirstName = FocusNode();
  final FocusNode _focusLastName = FocusNode();
  final FocusNode _focusPhone = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusConfirmPassword = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final RegisterBloc _registerBloc = sl<RegisterBloc>();
  ProgressDialog _pbLoading;
  String pinCodeData = '';
  FToast fToast;

  @override
  void initState() {
    super.initState();
    needHideKeyboard();
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
    _phoneController.addListener(_onPhoneChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);

    fToast = FToast();
    fToast.init(context);

    if (widget.socialLoginData != null) {
      _firstNameController.text = widget.socialLoginData.firstName ??
          (widget.socialLoginData.name ?? '');
      _lastNameController.text = widget.socialLoginData.lastName ?? '';
      _emailController.text = widget.socialLoginData.email ?? '';
      if (widget.socialLoginData.email?.isNotEmpty ?? false) {
        _registerBloc.add(HasSocialEmail());
      }
    }

    _registerBloc.listen((state) {
      if (state.registerStatus != null) {
        _pbLoading.hide();
        FocusScope.of(context).requestFocus(FocusNode());
        switch (state.registerStatus) {
          case RegisterStatus.registerSuccess:
            break;
          case RegisterStatus.getProfileSuccess:
            if (!state.userInfo.isActivated()) {
              NavigateUtil.openPage(context, VerifyCodeScreen.routeName);
              return;
            }
            if (state.userInfo.hasFillPersonalization == 0) {
              if (isMVP) {
                NavigateUtil.openPage(
                    context, CongratulationRegisterScreen.routeName, argument: {
                  RouteArgument.type: CongratulationEnum.REGISTER
                });
              } else {
                NavigateUtil.openPage(context, PersonalizationScreen.routeName);
              }

              return;
            }
            NavigateUtil.openPage(context, MainScreen.routeName);
            break;
          case RegisterStatus.verifyCodeFail:
            _showToast(Lang.verify_error.tr());
            break;
          case RegisterStatus.alreadyRegister:
            // NavigateUtil.replacePage(context, LoginPage.routeName);
            _showToast(Lang.register_register_existed.tr());
            return;
          case RegisterStatus.failed:
            _showToast(Lang.register_register_failed.tr());
            break;
          default:
        }
      } else if (state.currentRoute == RegisterRoute.popBack) {
        FocusScope.of(context).requestFocus(FocusNode());
        NavigateUtil.pop(context);
      } else if (_pbLoading.isShowing()) {
        _pbLoading.hide();
      }
    });
    _registerBloc.add(LoadCountryCode());
  }

  @override
  Future<bool> onCustomBackPress() {
    _registerBloc.add(DoBackRoute());
    return Future(() => false);
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    return makeParent(Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffFDFBF5),
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _registerBloc.add(DoBackRoute());
              },
            ),
            actions: [
              // ignore: prefer_const_literals_to_create_immutables
              const IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.transparent,
                ),
              )
            ],
            elevation: 0,
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              maxLine: 2,
              textAlign: TextAlign.center,
              textStyle: textSmallxxx.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
              text: Lang.register_make_profile_and_buck.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _registerBloc,
                child: BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            right: sizeNormal,
                            left: sizeNormal,
                            bottom: sizeImageNormalx),
                        child: getLayoutByState(state),
                      )),
                      (state.currentRoute == RegisterRoute.enterInformationForm)
                          ? Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: sizeSmall, bottom: sizeSmall),
                                      child: MyButton(
                                        paddingHorizontal: sizeImageNormal,
                                        text: Lang.done.tr(),
                                        disable: !state.ableToRegister,
                                        disableColor: const Color(0xffA7A8BB),
                                        onTap: () => doRegister(state),
                                        isFillParent: false,
                                        textStyle: textNormal.copyWith(
                                            color: Colors.white),
                                        buttonColor: const Color(0xff242655),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: sizeSmallxxx,
                                    ),
                                    Text.rich(TextSpan(
                                      text: Lang.started_already_have_an_account
                                          .tr(),
                                      style: textSmallx.copyWith(
                                          color: const Color(0xffFDCB6B)),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: Lang.started_login.tr(),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              NavigateUtil.openPage(
                                                  context, LoginPage.routeName);
                                            },
                                          style: textSmallx.copyWith(
                                              color: const Color(0xffFDCB6B),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                    const SizedBox(
                                      height: sizeSmallxxx,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget buildInformationForm(BuildContext context, RegisterState state) {
    return Form(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MyInputField(
                  focusNode: _focusFirstName,
                  nextFocusNode: _focusLastName,
                  textHint: Lang.register_enter_first_name.tr(),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  textController: _firstNameController,
                  errorMessage: state.isFirstNameValid
                      ? null
                      : Lang.login_invalid_first_name.tr(),
                ),
              ),
              const SizedBox(
                width: sizeSmallxxx,
              ),
              Expanded(
                child: MyInputField(
                  focusNode: _focusLastName,
                  nextFocusNode: _focusPhone,
                  textHint: Lang.register_enter_last_name.tr(),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  textController: _lastNameController,
                  errorMessage: state.isLastNameValid
                      ? null
                      : Lang.login_invalid_last_name.tr(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: sizeSmallxxx,
          ),
          PhoneNumberFormField(
            focusNode: _focusPhone,
            text: state.countrySelected?.dialCode ?? '',
            onPressCountryCode: () => onPressCountryCode(context, state),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (v) {
              FocusScope.of(context).unfocus();
            },
            textController: _phoneController,
            errorMessage: state.isPhoneValid
                ? null
                : Lang.login_invalid_mobile_phone.tr(),
          ),
          const SizedBox(
            height: sizeSmallxxx,
          ),
          DateTimeField(
            textStyle: textSmallxxx.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black),
            selectedDate: state.selectedDate,
            label: Lang.register_enter_date_birth.tr(),
            dateFormat: DateFormat(DateUtil.DATE_FORMAT_DDMMYYYY),
            mode: DateFieldPickerMode.date,
            onDateSelected: (DateTime date) {
              FocusScope.of(context).unfocus();
              _registerBloc.add(OnSelectDOB(date));
            },
            lastDate:
                DateTime.now().subtract(const Duration(days: 365 * 13 + 4)),
          ),
          (state.selectedDate == null ||
                  DateUtil.isValidDOB(state.selectedDate))
              ? const SizedBox()
              : Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                      left: sizeSmall, top: sizeVerySmall),
                  child: MyTextView(
                    textAlign: TextAlign.start,
                    text: Lang.login_invalid_dob.tr(),
                    textStyle: textSmall.copyWith(color: Colors.redAccent),
                  ),
                ),
          const SizedBox(
            height: sizeSmallxxx,
          ),
          _buildGenderWidget(state),
        ],
      ),
    );
  }

  bool checkStateButton(RegisterState state) {
    switch (state.currentRoute) {
      case RegisterRoute.enterInformationForm:
        return !state.ableToRegister;
      default:
        return true;
    }
  }

  Widget buildRegisterForm(BuildContext context, RegisterState state) {
    return Form(
      child: Column(
        children: <Widget>[
          MyInputField(
            focusNode: _focusEmail,
            nextFocusNode: _focusPassword,
            textHint: Lang.register_enter_email.tr(),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            isEnable: state.hasSocialEmail != 1,
            textController: _emailController,
            errorMessage:
                state.isEmailValid ? null : Lang.login_invalid_email.tr(),
          ),
          const SizedBox(
            height: sizeSmallxxx,
          ),
          MyInputField(
            focusNode: _focusPassword,
            textHint: Lang.register_enter_password.tr(),
            nextFocusNode: _focusConfirmPassword,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            textController: _passwordController,
            hasPasswordRule: true,
            hasUppercase: state.hasUppercase ?? true,
            hasDigits: state.hasDigits ?? true,
            keyboardType: TextInputType.visiblePassword,
            hasSpecialCharacters: state.hasSpecialCharacters ?? true,
            hasSpaceCharacters: state.hasSpaceCharacters ?? true,
            hasMinLength: state.hasMinLength ?? true,
          ),
          const SizedBox(
            height: sizeSmallxxx,
          ),
          MyInputField(
            focusNode: _focusConfirmPassword,
            textHint: Lang.register_enter_re_password.tr(),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            onFieldSubmitted: (v) => doRegister(state),
            textController: _confirmPasswordController,
            errorMessage: state.isPasswordMatched
                ? null
                : Lang.register_confirm_password_not_matched.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderWidget(RegisterState registerState) {
    print("langCodelangCodelangCodelangCode " + langCode);
    return GestureDetector(
      onTap: () => showDialogGender(context, registerState),
      child: Container(
        margin: const EdgeInsets.only(top: sizeSmall),
        padding: const EdgeInsets.all(sizeSmall + 1),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 0.5,
                offset: const Offset(0, 0.5), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            MyTextView(
              textAlign: TextAlign.start,
              text: Lang.register_enter_marital_status.tr(),
              textStyle: textSmall.copyWith(color: const Color(0x32212237)),
            ),
            MyTextView(
              textAlign: TextAlign.start,
              text: langCode.toUpperCase() == PARAM_EN
                  ? registerState?.maritalStatusSelected?.nameEn ?? ''
                  : registerState?.maritalStatusSelected?.nameAr ?? '',
              textStyle: textSmallxx.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _onFirstNameChanged() {
    _registerBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _registerBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPhoneChanged() {
    _registerBloc.add(PhoneChanged(phone: _phoneController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onConfirmPasswordChanged() {
    _registerBloc.add(ConfirmPasswordChanged(
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text));
  }

  void doRegister(RegisterState state) {
    if (!state.ableToRegister || !canNextPhase(state)) {
      _showToast(Lang.register_please_fill_all_fields.tr());
      return;
    }
    _pbLoading.show();
    _registerBloc.add(RegisterButtonPressed(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        dob: DateUtil.dateFormatDDMMYYYY(state.selectedDate, locale: 'en'),
        type: getTypeByEnum(widget.registerEnum),
        dialCode: state.countrySelected?.dialCode ?? '',
        maritalId: state.maritalStatusSelected.id.toString(),
        socialId: getSocialIdByEnum(widget.registerEnum,
            widget?.socialLoginData?.id ?? '', _emailController.text),
        hasSocialEmail: state.hasSocialEmail));
  }

  bool canNextPhase(RegisterState state) {
    return _firstNameController.text.length >= 3 &&
        _lastNameController.text.length >= 3 &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        (_passwordController.text == _confirmPasswordController.text) &&
        _confirmPasswordController.text.isNotEmpty &&
        state.isPhoneValid &&
        (state.selectedDate != null && DateUtil.isValidDOB(state.selectedDate));
  }

  ///Get correct layout by state
  Widget getLayoutByState(RegisterState state) {
    switch (state.currentRoute) {
      case RegisterRoute.enterInformationForm:
        return Column(
          children: [enterInformationForm(state), enterRegisterForm(state)],
        );
      case RegisterRoute.enterPinCode:
        return enterVerifyCode(state);
      default:
        return enterRegisterForm(state);
    }
  }

  ///Render information Form Widget
  Widget enterInformationForm(RegisterState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin:
              const EdgeInsets.only(left: sizeLargexxx, right: sizeLargexxx),
          alignment: Alignment.center,
          child: MyTextView(
            textStyle: textSmallx.copyWith(color: Colors.grey[850]),
            text: Lang.register_by_making_account.tr(),
          ),
        ),
        const SizedBox(
          height: sizeLarge,
        ),
        MyTextView(
          textStyle: textSmall.copyWith(color: Colors.grey[700]),
          textAlign: TextAlign.start,
          text: Lang.register_the_entered_data_will_be_used_to_enhance.tr(),
        ),
        buildInformationForm(context, state),
      ],
    );
  }

  ///Render Register Form Widget
  Widget enterRegisterForm(RegisterState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          height: sizeSmallxxx,
        ),
        buildRegisterForm(context, state),
      ],
    );
  }

  ///Render Verify Code Form Widget
  Widget enterVerifyCode(RegisterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyTextView(
          text: Lang.forgot_password_enter_the_6_digit_code_sent.tr(),
          textStyle: textSmallx.copyWith(color: Colors.black),
        ),
        const SizedBox(
          height: sizeLarge,
        ),
        Container(
          margin: const EdgeInsets.only(left: sizeNormal, right: sizeNormal),
          child: PinCode(
            length: 6,
            obscureText: false,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            animationType: AnimationType.fade,
            pinTheme: MyPinTheme(
              shape: MyPinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(sizeVerySmall),
              fieldHeight: sizeLarge,
              borderWidth: 0,
              selectedFillColor: Colors.blue.withAlpha(100),
              fieldWidth: sizeLarge,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            keyboardType: TextInputType.number,
            enablePinAutofill: false,
            enableActiveFill: true,
            autoDisposeControllers: false,
            onCompleted: (v) {
              pinCodeData = v;
            },
            onChanged: (value) {
              pinCodeData = value;
            },
            beforeTextPaste: (text) {
              print('Allowing to paste $text');
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            appContext: context,
          ),
        ),
        const SizedBox(
          height: sizeNormal,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: Lang.forgot_password_did_get_code.tr(),
            style: textSmallx,
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (state.timeResend == 0) {
                      _pbLoading.show();
                      _registerBloc.add(DoResendCode());
                    }
                  },
                text:
                    ' ${state.timeResend == 0 ? Lang.forgot_password_resend_code.tr() : ('${Lang.forgot_password_resend_in.tr()} '
                        '${state.timeResend}')}',
                style: textSmallx.copyWith(
                  color: const Color(0xffFDCB6B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: sizeLarge,
        ),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormal, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.register_create_account.tr(),
            onTap: doSubmitPinCode,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  ///Check validate pinCode data and submit to Server
  void doSubmitPinCode() {
    final code = pinCodeData;
    final errMessageCode = validateCodePassword(code);
    if (code.isNotEmpty && (errMessageCode?.isEmpty ?? true)) {
      _pbLoading.show();
      _registerBloc.add(SubmitVerifyCode(
          code: code, tokenCode: _registerBloc.state.tokenCode));
    } else {
      UIUtil.showToast(Lang.forgot_password_invalid_did_code.tr());
    }
  }

  void showDialogGender(BuildContext context, RegisterState state) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) => MaritalDialog(
          listMarital: state.listMarital,
          maritalSelected: state.maritalStatusSelected,
          onSelectMarital: onSelectMarital,
        ),
      );
    } else {
      showModalBottomSheet(
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext builder) {
            return CupertinoPickerView(
              listData: state.listMarital,
              positionSelected:
                  state.listMarital.indexOf(state.maritalStatusSelected),
              onSelectedItemChanged: (value) =>
                  onSelectMarital(state.listMarital[value]),
              listWidget:
                  List<Widget>.generate(state.listMarital.length, (int index) {
                return Center(
                  child: MyTextView(
                    text: langCode.toUpperCase() == PARAM_EN
                        ? state.listMarital[index].nameEn
                        : state.listMarital[index].nameAr,
                    textStyle: textSmallxxx.copyWith(color: Colors.black),
                  ),
                );
              }),
            );
          });
    }
  }

  void onPressCountryCode(BuildContext context, RegisterState state) {
    if (state.listCountry == null || state.listCountry.isEmpty) {
      return;
    }
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CountryDialog(
          listCountry: state.listCountry,
          countrySelected: state.countrySelected,
          onSelectCountry: onSelectCountry,
        ),
      );
    } else {
      showModalBottomSheet(
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext builder) {
            return CupertinoPickerView(
              listData: state.listCountry,
              positionSelected:
                  state.listCountry.indexOf(state.countrySelected),
              onSelectedItemChanged: (value) =>
                  onSelectCountry(state.listCountry[value]),
              listWidget:
                  List<Widget>.generate(state.listCountry.length, (int index) {
                return Center(
                  child: MyTextView(
                    text:
                        '${state.listCountry[index].name}(${state.listCountry[index].dialCode})',
                    textStyle: textSmallxxx.copyWith(color: Colors.black),
                  ),
                );
              }),
            );
          });
    }
  }

  void onSelectMarital(MaritalStatus newValue) {
    _registerBloc.add(OnSelectMarital(maritalStatus: newValue));
    FocusScope.of(context).requestFocus(_focusEmail);
  }

  void onSelectCountry(Country newValue) {
    _registerBloc.add(OnSelectCountryCode(countryStatus: newValue));
    FocusScope.of(context).requestFocus(_focusPhone);
  }

  void _showToast(messages) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextView(
              text: messages,
              textStyle: textSmallxxx.copyWith(color: Colors.white))
        ],
      ),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 1),
        positionedToastBuilder: (context, child) {
          return Positioned(
            left: 24.0,
            right: 24.0,
            bottom: 120.0,
            child: child,
          );
        });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _focusFirstName.dispose();
    _focusLastName.dispose();
    _focusPhone.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    _focusConfirmPassword.dispose();

    _registerBloc.close();
    super.dispose();
  }
}
