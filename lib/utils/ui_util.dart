import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/constants.dart';
import '../common/dialog/menu_event_detail_dialog.dart';
import '../common/dialog/menu_notification_detail_dialog.dart';
import '../common/localization/lang.dart';
import '../common/theme/theme.dart';
import '../common/widget/my_text_view.dart';
import '../data/model/events.dart';
import '../data/model/events_detail.dart';
import '../data/model/notification_history_model.dart';
import 'navigate_util.dart';

class UIUtil {
  static const ARR_BG_AVATAR = [
    Colors.pinkAccent,
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.redAccent,
    Colors.amberAccent,
    Colors.cyan,
    Colors.deepOrange,
  ];

  static ImageProvider makeImageDecoration(
    String url, {
    FilterQuality filterQuality = FilterQuality.medium,
  }) {
    url = (url == null || url.isEmpty) ? Res.default_bg : url;
    ImageProvider imgProvider;
    if (url.contains('http') || url.contains('https')) {
      imgProvider = ExtendedImage.network(
        url,
        cache: true,
        enableMemoryCache: true,
        filterQuality: filterQuality,
      ).image;
    } else {
      imgProvider = AssetImage(url);
    }
    return imgProvider;
  }

  static Widget makeImageWidget(
    String url, {
    double width,
    double height,
    String placeHolder,
    bool useOldImageOnUrlChange,
    Size size,
    BoxFit boxFit,
    Color color,
    BorderRadius borderRadius,
    BlendMode blendMode,
    FilterQuality filterQuality,
  }) {
    if (size != null) {
      width = size.width;
      height = size.height;
    }
    filterQuality = filterQuality ?? FilterQuality.low;

    url = (url == null || url.isEmpty) ? '' : url;
    Widget imgWidget;
    if (url.contains('http') || url.contains('https')) {
      if (url.contains('svg')) {
        imgWidget = SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: boxFit,
          color: color,
        );
      } else {
        imgWidget = ExtendedImage.network(
          url,
          width: width,
          height: height,
          cache: true,
          borderRadius: borderRadius,
          filterQuality: filterQuality,
          fit: boxFit,
        );
      }
    } else if (url.contains('assets')) {
      imgWidget = ExtendedImage.asset(
        url,
        width: width,
        height: height,
        colorBlendMode: blendMode,
        color: color,
        fit: boxFit,
      );
    } else {
      imgWidget = const SizedBox();
    }
    return imgWidget;
  }

  static Widget makeCircleImageWidget(
    String url, {
    double size,
    Color color = Colors.amber,
    Color blendColor,
    bool shadowOn = false,
    String initialName,
    TextStyle textStyle,
  }) {
    if ((url == null || url.isEmpty) &&
        initialName != null &&
        initialName.isNotEmpty) {
      textStyle = textStyle ?? textNormal;
      // final listWords = initialName.trim().split(' ');
      // final lastWord = listWords[listWords.length - 1];
      final firstCharacter = initialName[0].toUpperCase();

      var sumCharsCode = 0;
      initialName.codeUnits.forEach((e) => sumCharsCode += e);
      final pickRandomBgColor = sumCharsCode % ARR_BG_AVATAR.length;
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: shadowOn
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: size * 0.08,
                    blurRadius: size * 0.04,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ]
              : null,
          shape: BoxShape.circle,
          color: ARR_BG_AVATAR[pickRandomBgColor],
        ),
        child: MyTextView(
          text: firstCharacter,
          textStyle: textStyle.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            boxShadow: shadowOn
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: size * 0.08,
                      blurRadius: size * 0.04,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ]
                : null,
            shape: BoxShape.circle,
            color: color,
            image: DecorationImage(
                fit: BoxFit.cover, image: makeImageDecoration(url))));
  }

  static void showToast(
    String mess, {
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    double fontSize = sizeSmallxxx,
  }) {
    Fluttertoast.showToast(
      msg: mess,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static Future<dynamic> showDialogAnimation(
      {Widget child,
      BuildContext context,
      bool isSlideDown = true,
      bool hasDragDismiss = false}) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          var valueSlide = -1;
          if (isSlideDown) {
            valueSlide = 1;
          }
          final curvedValue = Curves.linearToEaseOut.transform(a1.value) - 1;

          return Transform(
            transform: Matrix4.translationValues(
                0.0, curvedValue * valueSlide * 300, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: hasDragDismiss ? 0 : 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  static Future<bool> checkPermissionCameraAndPhoto(
      BuildContext context) async {
    final status = await Permission.camera.status;
    final statusPhoto = await Permission.photos.status;
    var statuses = <Permission, PermissionStatus>{};
    if (status.isPermanentlyDenied || statusPhoto.isPermanentlyDenied) {
      showDialogOpenSetting(context);
    } else if (status.isDenied || statusPhoto.isDenied) {
      showDialogOpenSetting(context);
    } else {
      statuses = await [
        Permission.camera,
        Permission.photos,
      ].request();
      if (statuses[Permission.camera].isDenied ||
          statuses[Permission.photos].isDenied) {
        showDialogOpenSetting(context);
      }
    }
    return (status.isGranted || statuses[Permission.camera].isGranted ??
            false) &&
        (statusPhoto.isGranted || statuses[Permission.photos].isGranted ??
            false);
  }

  static Future<bool> checkPermissionCamera(BuildContext context) async {
    final status = await Permission.camera.status;
    var statuses = <Permission, PermissionStatus>{};
    if (status.isPermanentlyDenied) {
      showDialogOpenSetting(context);
    } else if (status.isDenied) {
      showDialogOpenSetting(context);
    } else {
      statuses = await [
        Permission.camera,
      ].request();
      if (statuses[Permission.camera].isDenied) {
        showDialogOpenSetting(context);
      }
    }
    return status.isGranted || statuses[Permission.camera].isGranted;
  }

  static void showDialogOpenSetting(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: MyTextView(
            text: Lang.community_post_photo_access_to_the_camera_roll.tr(),
            textStyle: textNormal.copyWith(color: Colors.black),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              onPressed: () async {
                await openAppSettings();
                NavigateUtil.pop(context);
              },
              child: MyTextView(
                text: Lang.community_post_photo_settings.tr(),
                textStyle: textNormal.copyWith(color: Colors.black),
              ),
            ),
            FlatButton(
              onPressed: () {
                NavigateUtil.pop(context);
              },
              child: MyTextView(
                text: 'OK',
                textStyle: textNormal.copyWith(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showEventDialogMenu(
      {BuildContext context,
      EventDetailInfo eventDetailInfo,
      EventInfo eventInfo,
      Function() onRemovePost,
      Function() onTurnOffPost}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(sizeNormal),
              topRight: Radius.circular(sizeNormal)),
        ),
        child: MenuEventDetailDialog(
          eventDetailInfo: eventDetailInfo,
          eventInfo: eventInfo,
          onRemovePost: onRemovePost,
          onTurnOffPost: onTurnOffPost,
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  static void showNotificationDialogMenu(
      {BuildContext context,
      NotificationHistoryModel historyModel,
      Function() onRemoveNotification,
      Function() onTurnOffNotification}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(sizeNormal),
              topRight: Radius.circular(sizeNormal)),
        ),
        child: MenuNotificationDetailDialog(
          historyModel: historyModel,
          onRemoveNotification: onRemoveNotification,
          onTurnOffNotification: onTurnOffNotification,
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  static IconData getCircleIconBack(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? Icons.keyboard_arrow_left
        : Icons.keyboard_arrow_right;
  }

  static IconData getIconBack(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? Icons.arrow_back_ios
        : Icons.arrow_forward_ios;
  }

  static IconData getCircleIconNext(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? Icons.keyboard_arrow_right
        : Icons.keyboard_arrow_left;
  }

  static Alignment getAlignment(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }


  static Alignment getAlignmentENRight(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? Alignment.centerRight
        : Alignment.centerLeft;
  }


  static BoxDecoration getFirstDayBoxDecorationByLang(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? const BoxDecoration(
            color: Color(0xff419C9B),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0),
            ))
        : const BoxDecoration(
            color: Color(0xff419C9B),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ));
  }

  static BoxDecoration getLastDayBoxDecorationByLang(BuildContext context) {
    return context.locale.languageCode.toUpperCase() == PARAM_EN
        ? const BoxDecoration(
            color: Color(0xff419C9B),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ))
        : const BoxDecoration(
            color: Color(0xff419C9B),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0),
            ));
  }


  static String languageCode(BuildContext context) {
    return context.locale.languageCode;
  }
}
