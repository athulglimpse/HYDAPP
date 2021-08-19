import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/notification_setting_model.dart';
import '../../utils/my_custom_route.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../congratulation_register/congratulation_regiter_page.dart';
import 'bloc/notification_setting_bloc.dart';

class NotificationSettingScreen extends BaseWidget {
  static const routeName = '/NotificationSettingScreen';
  final bool firstTime;
  NotificationSettingScreen(this.firstTime);

  @override
  State<StatefulWidget> createState() {
    return NotificationSettingScreenState();
  }
}

class NotificationSettingScreenState
    extends BaseState<NotificationSettingScreen> {
  ProgressDialog _pbLoading;
  final NotificationSettingBloc _notificationSettingBloc =
      sl<NotificationSettingBloc>();

  @override
  void initState() {
    super.initState();
    _notificationSettingBloc.add(FetchNotificationData());
    _notificationSettingBloc.listen((state) {
      if (_pbLoading.isShowing()) {
        _pbLoading.hide();
      }

      if (state.success) {
        if (widget.firstTime) {
          NavigateUtil.replacePage(
              context, CongratulationRegisterScreen.routeName,
              argument: {RouteArgument.type: CongratulationEnum.REGISTER});
        } else {
          NavigateUtil.pop(context);
        }
      } else if (state.errorMessage?.isNotEmpty ?? false) {
        UIUtil.showToast(state.errorMessage);
      }
    });
  }

  void initBasicInfo() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              NavigateUtil.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: MyTextView(
            textAlign: TextAlign.center,
            textStyle: textNormal.copyWith(color: Colors.black),
            text: Lang.notification_setting_pick_the_notifications_you_get.tr(),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: sizeLargexx),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: sizeSmallxx,
                        left: sizeLargexxx,
                        right: sizeLargexxx),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: MyTextView(
                      textStyle: textSmallx.copyWith(color: Colors.grey[850]),
                      text: Lang
                          .notification_setting_choose_which_notification_you_want
                          .tr(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: BlocProvider(
                create: (_) => _notificationSettingBloc,
                child: BlocBuilder<NotificationSettingBloc,
                    NotificationSettingState>(builder: (context, state) {
                  if (state.notificationItemList == null ||
                      state.notificationItemList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                        left: sizeNormalxx, right: sizeNormalxx),
                    itemCount: state.notificationItemList.length,
                    itemBuilder: (context, position) {
                      return notificationItemWidget(
                          state.notificationItemList[position]);
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(sizeNormalxx),
              child: MyButton(
                paddingHorizontal: sizeImageSmall,
                text: Lang.done.tr(),
                height: sizeLargexx,
                minWidth: sizeImageLarge,
                onTap: () {
                  _pbLoading.show();
                  _notificationSettingBloc.add(OnSubmitNotificationSetting());
                },
                isFillParent: false,
                textStyle: textSmallxxx.copyWith(color: Colors.white),
                buttonColor: const Color(0xff242655),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget notificationItemWidget(NotificationSettingModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: sizeSmall),
      child: Column(
        children: [
          Row(
            children: [
              // UIUtil.makeImageWidget(item.type, width: sizeNormalxx),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: sizeNormal),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: MyTextView(
                          textAlign: TextAlign.start,
                          text: getName(item.type),
                          maxLine: 2,
                          textStyle: textSmallxxx.copyWith(color: Colors.black),
                        ),
                      ),
                      CupertinoSwitch(
                        value: item.isOn,
                        activeColor: const Color(0xffFBBC43),
                        onChanged: (val) {
                          _notificationSettingBloc
                              .add(OnNotificationItemChange(item));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: sizeSmall, left: sizeLargexx),
            color: const Color(0xff212237).withOpacity(0.1),
          )
        ],
      ),
    );
  }


  String getName(String type) {
    if (type.contains('anoucemance.png')) {
      return Lang.notification_setting_anoucemance.tr();
    } else if (type.contains('upcome.png')) {
      return Lang.notification_setting_upcome.tr();
    } else if (type.contains('community.png')) {
      return Lang.notification_setting_community.tr();
    } else if (type.contains('approve.png')) {
      return Lang.notification_setting_approve.tr();
    }
  }

  @override
  void dispose() {
    _notificationSettingBloc.close();
    super.dispose();
  }
}
