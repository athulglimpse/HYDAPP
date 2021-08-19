import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/ui/congratulation_register/congratulation_regiter_page.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/dialog/contry_dialog.dart';
import '../../common/dialog/cupertino_picker.dart';
import '../../common/dialog/help_report_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_input_field.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/country.dart';
import '../../data/model/help_report_model.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../register/component/phone_number_form_field.dart';
import 'bloc/help_bloc.dart';
import 'bloc/help_event.dart';
import 'bloc/help_state.dart';

class HelpPage extends BaseWidget {
  static const routeName = 'HelpPage';

  HelpPage();

  @override
  State<StatefulWidget> createState() {
    return HelpPageState();
  }
}

class HelpPageState extends BaseState<HelpPage> {
  final _helpBloc = sl<HelpBloc>();
  final FocusNode _focusPhone = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusDescription = FocusNode();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    _phoneController.addListener(_onPhoneChanged);
    _emailController.addListener(_onEmailChanged);
    _descriptionController.addListener(_onDescriptionChanged);

    if (_helpBloc.state.email?.isNotEmpty ?? false) {
      _emailController.text = _helpBloc.state.email;
    }
    if (_helpBloc.state.phone?.isNotEmpty ?? false) {
      _phoneController.text = _helpBloc.state.phone;
    }

    _helpBloc.add(FetchHelpItems());
    _helpBloc.add(LoadCountryCode());
    _helpBloc.listen((state) {
      _pbLoading.hide();
      if (state.isSuccess) {
        // UIUtil.showToast(Lang.help_your_form_is_successfully_submitted.tr());
        NavigateUtil.replacePage(
            context, CongratulationRegisterScreen.routeName,
            argument: {'type': CongratulationEnum.HELP});
      } else if (state.isError) {
        NavigateUtil.replacePage(
            context, CongratulationRegisterScreen.routeName,
            argument: {'type': CongratulationEnum.ERROR});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              iconSize: sizeSmallxxx,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                NavigateUtil.pop(context);
              },
            ),
            elevation: 0,
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              textStyle: textNormal.copyWith(
                  color: Colors.black,
                  fontFamily: MyFontFamily.publicoBanner,
                  fontWeight: MyFontWeight.bold),
              text: Lang.more_help.tr(),
            ),
          ),
          body: BlocProvider(
            create: (_) => _helpBloc,
            child: BlocBuilder<HelpBloc, HelpState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      color: const Color(0xffFDFBF5),
                      padding: const EdgeInsets.all(sizeNormalxx),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          renderUserInfo(state),
                          const SizedBox(height: sizeNormalxx),
                          MyButton(
                            paddingHorizontal: sizeImageSmall,
                            text: Lang.help_send.tr(),
                            onTap: () {
                              _onSenHelp(state);
                            },
                            isFillParent: false,
                            textStyle: textNormal.copyWith(color: Colors.white),
                            buttonColor: const Color(0xff242655),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget renderUserInfo(HelpState state) {
    return Form(
      child: Column(
        children: [
          MyInputField(
            focusNode: _focusEmail,
            textHint: Lang.register_enter_email.tr(),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            textController: _emailController,
            errorMessage:
                state.isEmailValid ? null : Lang.login_invalid_email.tr(),
          ),
          const SizedBox(height: sizeSmallxxx),
          PhoneNumberFormField(
            focusNode: _focusPhone,
            text: state.countrySelected?.dialCode ?? '',
            onPressCountryCode: () => onPressCountryCode(context, state),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            textController: _phoneController,
            errorMessage: state.isPhoneValid
                ? null
                : Lang.login_invalid_mobile_phone.tr(),
          ),
          const SizedBox(height: sizeSmallxxx),
          GestureDetector(
            onTap: () => showDialogHelpItems(context, state),
            child: Container(
              margin: const EdgeInsets.only(top: sizeSmall),
              padding: const EdgeInsets.all(sizeSmall + 1),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset:
                          const Offset(0, 0.5), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeSmall))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        MyTextView(
                          textAlign: TextAlign.start,
                          text: Lang.help_select_how_we_could_help.tr(),
                          textStyle: textSmall.copyWith(
                              color: const Color(0x32212237)),
                        ),
                        MyTextView(
                          textAlign: TextAlign.start,
                          text: (state.currentHelpItem != null)
                              ? state.currentHelpItem.name
                              : Lang.help_report_a_problem.tr(),
                          textStyle: textSmallxx.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      child: Icon(Icons.keyboard_arrow_down,
                          size: sizeSmallxxxx,
                          color: const Color(0xff212237).withOpacity(0.5))),
                ],
              ),
            ),
          ),
          const SizedBox(height: sizeSmallxxx),
          Container(
            margin: const EdgeInsets.only(top: sizeSmall),
            padding: const EdgeInsets.all(sizeVerySmall),
            decoration: BoxDecoration(
              boxShadow: [
                _focusDescription.hasFocus ?? false
                    ? BoxShadow(
                        color: const Color(0xffFDCB6B).withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall)),
            ),
            child: TextField(
              focusNode: _focusDescription,
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 200,
              autocorrect: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFffffff),
              ),
            ),
          ),
          !state.isDesValid
              ? Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                      left: sizeSmall, top: sizeVerySmall),
                  child: MyTextView(
                    textAlign: TextAlign.start,
                    text: Lang.help_please_input_at_least_10_characters.tr(),
                    textStyle: textSmall.copyWith(color: Colors.redAccent),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: sizeLarge),
        ],
      ),
    );
  }

  void onPressCountryCode(BuildContext context, HelpState state) {
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
            positionSelected: state.listCountry.indexOf(state.countrySelected),
            onSelectedItemChanged: (value) =>
                onSelectCountry(state.listCountry[value]),
            listWidget:
                List<Widget>.generate(state.listCountry.length, (int index) {
              return Center(
                child: MyTextView(
                  text: state.listCountry[index].name +
                      '(' +
                      state.listCountry[index].dialCode +
                      ')',
                  textStyle: textSmallxxx.copyWith(color: Colors.black),
                ),
              );
            }),
          );
        },
      );
    }
  }

  void showDialogHelpItems(BuildContext context, HelpState state) {
    if (state.helpItems == null || state.helpItems.isEmpty) {
      return;
    }
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) => HelpReportDialog(
          list: state.helpItems,
          itemSelected: state.currentHelpItem,
          onSelectItem: onSelectTypeIssue,
        ),
      );
    } else {
      showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPickerView(
            listData: state.helpItems,
            positionSelected: state.helpItems.indexOf(state.currentHelpItem),
            onSelectedItemChanged: (value) =>
                onSelectTypeIssue(state.helpItems[value]),
            listWidget: List<Widget>.generate(state.helpItems?.length ?? 0,
                (int index) {
              return Center(
                child: MyTextView(
                  text: state.helpItems[index].name,
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black,
                      fontFamily: Fonts.Helvetica,
                      fontWeight: MyFontWeight.regular),
                ),
              );
            }),
          );
        },
      );
    }
  }

  void onSelectTypeIssue(HelpReportModel newValue) {
    _helpBloc.add(OnSelectHelpItem(helpItem: newValue));
  }

  void onSelectCountry(Country newValue) {
    _helpBloc.add(OnSelectCountryCode(countryStatus: newValue));
  }

  void _onEmailChanged() {
    _helpBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPhoneChanged() {
    _helpBloc.add(PhoneChanged(phone: _phoneController.text));
  }

  void _onDescriptionChanged() {
    _helpBloc.add(DescriptionChanged(description: _descriptionController.text));
  }

  void _onSenHelp(HelpState state) {
    if (!state.isEmailValid || _emailController.text.isEmpty) {
      UIUtil.showToast(Lang.login_invalid_email.tr(),
        backgroundColor: Colors.red,);
      return;
    }
    if (!state.isPhoneValid || _phoneController.text.isEmpty) {
      UIUtil.showToast(Lang.login_invalid_mobile_phone.tr(),
        backgroundColor: Colors.red,);
      return;
    }
    if (!state.isDesValid || _descriptionController.text.length < 10) {
      UIUtil.showToast(Lang.help_please_input_at_least_10_characters.tr(),
        backgroundColor: Colors.red,);
      return;
    }

    _pbLoading.show();
    _helpBloc.add(SendHelp(
      content: _descriptionController.text,
      helpTopic: state.currentHelpItem?.id?.toString() ?? '',
      email: _emailController.text,
      mobile: _phoneController.text,
      dialCode: state.countrySelected.dialCode,
    ));
  }

  @override
  void dispose() {
    _helpBloc.close();

    _focusPhone.dispose();
    _focusEmail.dispose();
    _focusDescription.dispose();

    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
