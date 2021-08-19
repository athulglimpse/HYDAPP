import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/more_item.dart';
import '../../utils/navigate_util.dart';
import '../base/base_widget.dart';
import '../getstarted/get_started_page.dart';
import 'bloc/deactivate_account_bloc.dart';
import 'const_items.dart';

class DeactivateAccountPage extends BaseWidget {
  static const routeName = 'DeactivateAccountScreen';

  DeactivateAccountPage();

  @override
  State<StatefulWidget> createState() {
    return DeactivateAccountPageState();
  }
}

class DeactivateAccountPageState extends BaseState<DeactivateAccountPage> {
  final _deactivateAccountBloc = sl<DeactivateAccountBloc>();

  ProgressDialog _pbLoading;
  final FocusNode _focusDescription = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
    _deactivateAccountBloc.add(InitData(constMoreItems));
  }

  void initBasicInfo() {
    _deactivateAccountBloc.listen((state) {
      if (state.status == StatusDeActive.FAIL) {
        if (_pbLoading.isShowing()) {
          _pbLoading.hide();
        }
      }
      if (state is LogoutSuccess) {
        if (_pbLoading.isShowing()) {
          _pbLoading.hide();
        }
        NavigateUtil.openPage(context, StartedScreen.routeName, release: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffFDFBF5),
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                NavigateUtil.pop(context);
              },
            ),
            elevation: 0,
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              textAlign: TextAlign.center,
              textStyle: textNormal.copyWith(
                  color: Colors.black,
                  fontWeight: MyFontWeight.bold,
                  fontFamily: MyFontFamily.publicoBanner),
              text: Lang.deactivate_account_title.tr(),
            ),
          ),
          body: BlocProvider(
            create: (_) => _deactivateAccountBloc,
            child: BlocBuilder<DeactivateAccountBloc, DeactivateAccountState>(
                builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: sizeNormal),
                child: Container(
                  color: Colors.white,
                  height: sizeImageLargexxx + sizeImageLargexxx,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: sizeSmallxxx, vertical: sizeNormal),
                        color: const Color(0xffFDFBF5),
                        child: MyTextView(
                          text: Lang.deactivate_account_description.tr(),
                          textAlign: TextAlign.start,
                          textStyle: textSmallxx.copyWith(
                              color: const Color(0xff212237),
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.regular),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: sizeSmallxxx, vertical: sizeSmallxxx),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                                left: sizeSmallx, right: sizeSmallx),
                            itemCount: state.moreItems?.length ?? 0,
                            itemBuilder: (context, position) {
                              return DeactivateAccountItemWidget(
                                  state, state.moreItems[position], position);
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: sizeLarge),
                        child: MyButton(
                          minWidth: sizeImageLarge,
                          text: Lang.deactivate_account_button_deactivate.tr(),
                          onTap: () {
                            _pbLoading.show();
                            _deactivateAccountBloc.add(SubmitDeactivateAccount(
                                reason: state.currentValue == state.moreItems[5]
                                    ? _descriptionController.text
                                    : state.currentValue.name));
                          },
                          isFillParent: false,
                          textStyle: textNormal.copyWith(color: Colors.white),
                          buttonColor: const Color(0xff242655),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget DeactivateAccountItemWidget(
      DeactivateAccountState state, MoreItem item, int position) {
    return Theme(
      data: ThemeData(
        // Define the default brightness and colors.
        unselectedWidgetColor: const Color(0x80FBBC43),
        disabledColor: const Color(0x80FBBC43),
      ),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: item,
                  activeColor: const Color(0xffFBBC43),
                  hoverColor: const Color(0xffFBBC43),
                  focusColor: const Color(0xffFBBC43),
                  groupValue: state.currentValue,
                  onChanged: (value) {
                    _deactivateAccountBloc.add(OnSelectItem(value));
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _deactivateAccountBloc.add(OnSelectItem(item));
                    });
                  },
                  child: MyTextView(
                    text: item.name.tr(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            (position == 5 && state.currentValue == state.moreItems[5])
                ? Container(
                    margin: const EdgeInsets.only(top: sizeSmall),
                    padding: const EdgeInsets.all(sizeVerySmall),
                    decoration: BoxDecoration(
                      boxShadow: [
                        _focusDescription.hasFocus ?? false
                            ? BoxShadow(
                                color: const Color(0xffFDCB6B).withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 0.5,
                                offset: const Offset(
                                    0, 0.5), // changes position of shadow
                              )
                            : BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0.5,
                                blurRadius: 0.5,
                                offset: const Offset(
                                    0, 0.5), // changes position of shadow
                              ),
                      ],
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(sizeSmall)),
                    ),
                    child: TextField(
                      focusNode: _focusDescription,
                      controller: _descriptionController,
                      maxLines: 5,
                      maxLength: 200,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: textSmallxx.copyWith(
                            color: const Color(0xff212237).withOpacity(0.3),
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.regular),
                        labelStyle: textSmallxx.copyWith(
                            color: const Color(0xff212237),
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.regular),
                        hintText: Lang
                            .deactivate_account_enter_your_for_deactivating
                            .tr(),
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: const Color(0xFFffffff),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _deactivateAccountBloc.close();
    super.dispose();
  }
}
