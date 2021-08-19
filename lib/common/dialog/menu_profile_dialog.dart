import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/dialog/contry_dialog.dart';
import '../../common/dialog/cupertino_picker.dart';
import '../../data/model/app_config.dart';
import '../../data/model/country.dart';
import '../../data/model/user_info.dart';
import '../../ui/profile/bloc/bloc.dart';
import '../../ui/register/component/date_time_form_field.dart';
import '../../ui/register/component/phone_number_form_field.dart';
import '../../utils/date_util.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_button.dart';
import '../widget/my_text_view.dart';
import 'cupertino_picker_photo.dart';
import 'marital_dialog.dart';

class MenuProfileDialog extends StatefulWidget {
  final UserInfo userInfo;
  final ProfileBloc profileBloc;
  final ProfileState state;

  const MenuProfileDialog(
      {Key key, this.userInfo, this.profileBloc, this.state})
      : super(key: key);

  @override
  _MenuProfileDialogState createState() => _MenuProfileDialogState();
}

class _MenuProfileDialogState extends State<MenuProfileDialog> {
  final FocusNode _focusPhone = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    widget.profileBloc.add(ResetToUserInfo());

    _phoneController.addListener(_onPhoneChanged);
    widget.profileBloc.add(PhoneChanged(phone: _phoneController.text));
    _phoneController.text = widget.userInfo.phoneNumber;

    widget.profileBloc.listen((state) {
      if (state.status == ProfileStatus.FAIL) {
        _pbLoading.hide();
      } else if (state.status == ProfileStatus.SUCCESS) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.profile_update_profile_success.tr());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    return Padding(
      padding: const EdgeInsets.only(
          right: sizeNormal,
          left: sizeNormal,
          bottom: sizeNormal,
          top: sizeSmall),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: sizeSmallxxx),
              width: sizeNormalxxx,
              height: 4,
              decoration: const BoxDecoration(
                  color: Color(0x21212237),
                  borderRadius:
                      BorderRadius.all(Radius.circular(sizeVerySmall))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeNormal)),
                  child: widget.state.pathImage.isNotEmpty
                      ? Stack(
                          children: [
                            Image.file(
                              File(widget.state.pathImage),
                              fit: BoxFit.cover,
                              height: sizeExLargex,
                              width: sizeExLargex,
                            ),
                            Positioned.fill(
                              right: sizeVerySmall,
                              top: sizeVerySmall,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.profileBloc.add(RemoveUserPhoto());
                                  },
                                  child: Container(
                                    width: sizeSmallxxxx,
                                    height: sizeSmallxxxx,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(sizeNormalxxx),
                                        )),
                                    child: const Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                      size: sizeSmallx,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          height: sizeExLargex,
                          width: sizeExLargex,
                          child: (widget.userInfo?.photo?.url?.isNotEmpty ??
                                  false)
                              ? UIUtil.makeImageWidget(
                                  widget.userInfo?.photo?.url ?? Res.icon_user,
                                  size: const Size(sizeExLargex, sizeExLargex),
                                  boxFit: BoxFit.cover)
                              : const Icon(
                                  Icons.person,
                                  size: sizeExLargex,
                                  color: Colors.grey,
                                ),
                        ),
                ),
                const SizedBox(width: sizeSmallx),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      text: widget.userInfo?.fullName,
                      textStyle: textSmallxxx.copyWith(
                        color: const Color(0xff212237),
                        fontFamily: MyFontFamily.publicoBanner,
                        fontWeight: MyFontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: sizeSmallxxx),
                    MyTextView(
                      onTap: onAddImage,
                      text: Lang.profile_change_photo.tr(),
                      textStyle: textSmallxx.copyWith(
                        color: const Color(0xff419C9B),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey[350]),
            const SizedBox(height: sizeSmallxx),
            renderProfileInfo(widget.profileBloc.state),
            const SizedBox(height: sizeNormalxx),
            MyButton(
              paddingHorizontal: sizeLargexxx,
              text: Lang.profile_save_changes.tr(),
              onTap: () {
                onSaveChangeProfile(widget.profileBloc.state);
              },
              isFillParent: false,
              textStyle: textNormal.copyWith(color: Colors.white),
              buttonColor: const Color(0xff242655),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderProfileInfo(ProfileState state) {
    return Form(
      child: Column(
        children: [
          PhoneNumberFormField(
            focusNode: _focusPhone,
            text: state.countrySelected?.dialCode ?? '',
            onPressCountryCode: () => onPressCountryCode(context, state),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (v) {
              FocusScope.of(context).unfocus();
            },
            textController: _phoneController,
            errorMessage: state.isPhoneValid
                ? null
                : Lang.login_invalid_mobile_phone.tr(),
          ),
          const SizedBox(height: sizeSmallxxx),
          DateTimeField(
            textStyle: textSmallxxx.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black),
            selectedDate: state.selectedDate,
            label: Lang.register_enter_date_birth.tr(),
            dateFormat: DateFormat(DateUtil.DATE_FORMAT_DDMMYYYY),
            mode: DateFieldPickerMode.date,
            onDateSelected: (DateTime date) {
              widget.profileBloc.add(OnSelectDOB(date));
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
          const SizedBox(height: sizeSmallxxx),
          _buildMaritalWidget(state),
          const SizedBox(height: sizeNormalxx),
        ],
      ),
    );
  }

  Widget _buildMaritalWidget(ProfileState state) {
    return GestureDetector(
      onTap: () => showDialogGender(context, state),
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
                  ? state?.maritalStatusSelected?.nameEn ?? ''
                  : state?.maritalStatusSelected?.nameAr ?? '',
              textStyle: textSmallxx.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogGender(BuildContext context, ProfileState state) {
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

  void onPressCountryCode(BuildContext context, ProfileState state) {
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
                        // ignore: lines_longer_than_80_chars
                        '${state.listCountry[index].name}(${state.listCountry[index].dialCode})',
                    textStyle: textSmallxxx.copyWith(color: Colors.black),
                  ),
                );
              }),
            );
          });
    }
  }

  void onSelectCountry(Country newValue) {
    widget.profileBloc.add(OnSelectCountryCode(countryStatus: newValue));
  }

  void _onPhoneChanged() {
    widget.profileBloc.add(PhoneChanged(phone: _phoneController.text));
  }

  void onSelectMarital(MaritalStatus newValue) {
    widget.profileBloc.add(OnSelectMarital(maritalStatus: newValue));
  }

  void onSaveChangeProfile(ProfileState state) {
    if (!canNextPhase(state)) {
      UIUtil.showToast(
        Lang.register_please_fill_all_fields.tr(),
        backgroundColor: Colors.red,
      );
      return;
    }
    // NavigateUtil.pop(context);
    _pbLoading.show();
    widget.profileBloc.add(ProfileChanged(
        phone: _phoneController.text,
        dialCode: widget.state.countrySelected.dialCode,
        date: DateUtil.dateFormatDDMMYYYY(widget.state.selectedDate,
            locale: 'en'),
        marital: widget.state.maritalStatusSelected.id.toString()));
  }

  bool canNextPhase(ProfileState state) {
    return state.selectedDate != null &&
        state.isPhoneValid &&
        DateUtil.isValidDOB(state.selectedDate);
  }

  void onSelectPhoto(String path) {
    widget.profileBloc.add(ChangeUserPhoto(path));
  }

  void onPathImage(String path) {
    widget.profileBloc.add(ChangeUserPhoto(path));
  }

  void onAddImage() {
    FocusScope.of(context).unfocus();
    showCupertinoModalPopup(
        context: context,
        builder: (context) =>
            CupertinoPickerPhotoView(onSelectPhoto: onSelectPhoto));
  }

  @override
  void dispose() {
    _focusPhone.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
