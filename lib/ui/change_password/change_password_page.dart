import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_input_field.dart';
import '../../common/widget/my_text_view.dart';
import '../../utils/navigate_util.dart';
import 'package:marvista/utils/string_util.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../base/base_widget.dart';
import 'bloc/change_password_bloc.dart';

class ChangePasswordScreen extends BaseWidget {
  static const routeName = 'ChangePasswordScreen';

  ChangePasswordScreen();

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordScreenState();
  }
}

class ChangePasswordScreenState extends BaseState<ChangePasswordScreen> {
  final _change_passwordBloc = sl<ChangePasswordBloc>();
  final FocusNode _focusNewPassword = FocusNode();
  final FocusNode _focusConfirmNewPassword = FocusNode();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onPasswordChanged);
    _confirmNewPasswordController.addListener(_onConfirmPasswordChanged);

    initBasicInfo();
  }

  void initBasicInfo() {
    _change_passwordBloc.listen((state) {
      if (state is CheckOldPasswordState ||
          state.status == ChangePassStatus.CHECK_PASSWORD_SUCCESS) {
        if (_pbLoading.isShowing()) {
          _pbLoading.hide();
        }
      } else if (state.status == ChangePassStatus.CHANGE_PASSWORD_SUCCESS) {
        FocusScope.of(context).requestFocus(FocusNode());
        if (_pbLoading.isShowing()) {
          _pbLoading.hide();
        }
        NavigateUtil.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    super.build(context);
    return BlocProvider(
      create: (_) => _change_passwordBloc,
      child: Container(
        color: const Color(0xffFDFBF5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffFDFBF5),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  if (!(_change_passwordBloc.state is CheckOldPasswordState)) {
                    _change_passwordBloc.add(BackRoute());
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());
                    NavigateUtil.pop(context);
                  }
                },
              ),
              backgroundColor: const Color(0xffFDFBF5),
              title: MyTextView(
                textStyle: textNormal.copyWith(color: Colors.black),
                text: Lang.change_password_change_password.tr(),
              ),
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              return WillPopScope(
                onWillPop: () {
                  if (!(_change_passwordBloc.state is CheckOldPasswordState)) {
                    _change_passwordBloc.add(BackRoute());
                    return Future(() => false);
                  }
                  FocusScope.of(context).unfocus();
                  return Future(() => true);
                },
                child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                  builder: (context, state) {
                    if (state is CheckOldPasswordState) {
                      return Padding(
                        padding: const EdgeInsets.all(sizeNormal),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyTextView(
                              text: Lang
                                  .change_password_please_enter_your_old_password
                                  .tr(),
                              textStyle:
                                  textSmallx.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: sizeLarge),
                            Container(
                              margin: const EdgeInsets.only(top: sizeSmall),
                              padding: const EdgeInsets.all(sizeVerySmall),
                              child: MyInputField(
                                textHint:
                                    Lang.change_password_old_password.tr(),
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                onFieldSubmitted: (v) => doCheckOldPass(),
                                textController: _oldPasswordController,
                              ),
                            ),
                            const SizedBox(height: sizeLarge),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: sizeNormal, bottom: sizeSmall),
                              child: MyButton(
                                minWidth: sizeImageLarge,
                                text: Lang.change_password_check_password.tr(),
                                onTap: doCheckOldPass,
                                isFillParent: false,
                                textStyle:
                                    textNormal.copyWith(color: Colors.white),
                                buttonColor: const Color(0xff242655),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return formChangeNewPass(state);
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget formChangeNewPass(ChangePasswordState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTextView(
            text: Lang
                .change_password_please_enter_your_new_password_and_then_confirm
                .tr(),
            textStyle: textSmallx.copyWith(color: Colors.black),
          ),
          const SizedBox(height: sizeLarge),
          Container(
            margin: const EdgeInsets.only(left: sizeNormal, right: sizeNormal),
            child: Column(
              children: [
                MyInputField(
                  focusNode: _focusNewPassword,
                  textHint: Lang.forgot_password_new_password.tr(),
                  nextFocusNode: _focusConfirmNewPassword,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  textController: _newPasswordController,
                  hasPasswordRule: true,
                  hasUppercase: state.hasUppercase,
                  hasDigits: state.hasDigits,
                  hasSpecialCharacters: state.hasSpecialCharacters,
                  hasMinLength: state.hasMinLength ?? false,
                ),
                const SizedBox(height: sizeNormal),
                MyInputField(
                  focusNode: _focusConfirmNewPassword,
                  textHint: Lang.forgot_password_confirm_new_password.tr(),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  onFieldSubmitted: (v) => doSubmitNewPassword(),
                  textController: _confirmNewPasswordController,
                  errorMessage: state.isPasswordMatched
                      ? null
                      : Lang.register_confirm_password_not_matched.tr(),
                ),
              ],
            ),
          ),
          const SizedBox(height: sizeLarge),
          Padding(
            padding: const EdgeInsets.only(top: sizeNormal, bottom: sizeSmall),
            child: MyButton(
              minWidth: sizeImageLarge,
              text: Lang.forgot_password_resend_confirm.tr(),
              onTap: doSubmitNewPassword,
              isFillParent: false,
              textStyle: textNormal.copyWith(color: Colors.white),
              buttonColor: const Color(0xff242655),
            ),
          ),
        ],
      ),
    );
  }

  void doCheckOldPass() {
    final oldPassWord = _oldPasswordController.text;

    final errMessageNewPassWord = validatePassword(oldPassWord);

    //validate password
    if (errMessageNewPassWord?.isNotEmpty ?? false) {
      UIUtil.showToast(errMessageNewPassWord,
        backgroundColor: Colors.red,);
      return;
    }

    //Submit Data do Server
    _pbLoading.show();
    _change_passwordBloc.add(CheckOldPassword(oldPass: oldPassWord));
  }

  void doSubmitNewPassword() {
    final newPassWord = _newPasswordController.text;
    final confirmNewPassWord = _confirmNewPasswordController.text;

    final errMessageNewPassWord = validatePassword(newPassWord);
    final errMessageConfirmPassWord =
        validateRePassword(newPassWord, confirmNewPassWord);

    //validate password
    if (errMessageNewPassWord?.isNotEmpty ?? false) {
      UIUtil.showToast(errMessageNewPassWord,
        backgroundColor: Colors.red,);
      return;
    }

    //validate password and confirm password
    if (errMessageConfirmPassWord?.isNotEmpty ?? false) {
      UIUtil.showToast(errMessageConfirmPassWord,
        backgroundColor: Colors.red,);
      return;
    }

    //Submit Data do Server
    _pbLoading.show();
    _change_passwordBloc.add(SubmitNewPassword(
        newPass: newPassWord, tokenCode: _change_passwordBloc.state.tokenCode));
  }

  void _onPasswordChanged() {
    _change_passwordBloc
        .add(PasswordChanged(password: _newPasswordController.text));
  }

  void _onConfirmPasswordChanged() {
    _change_passwordBloc.add(ConfirmPasswordChanged(
        password: _newPasswordController.text,
        confirmPassword: _confirmNewPasswordController.text));
  }

  @override
  void dispose() {
    _change_passwordBloc.close();

    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();

    _focusNewPassword.dispose();
    _focusConfirmNewPassword.dispose();
    super.dispose();
  }
}
