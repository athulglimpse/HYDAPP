import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import '../common/di/injection/injector.dart';
import '../common/localization/lang.dart';
import '../data/model/personalization_item.dart';
import 'app_const.dart';
import 'firebase_wrapper.dart';

class Utils {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static bool isValidEmail(String email) => _emailRegExp.hasMatch(email);

  static bool isValidPassword(String password) => password.isNotEmpty;
//      _passwordRegExp.hasMatch(password);

  static bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpaceCharacters = !password.contains(RegExp(r'[\s]'));
    final hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length > minLength;
    return hasDigits &
        hasUppercase &
        hasSpecialCharacters &
        hasMinLength &
        hasSpaceCharacters;
  }

  static bool isPasswordUppercase(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    return hasUppercase;
  }

  static bool isPasswordDigits(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    return hasDigits;
  }

  static bool isPasswordHasSpaceCharacters(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    final hasSpaceCharacters = !password.contains(RegExp(r'[\s]'));
    return hasSpaceCharacters;
  }

  static bool isPasswordSpecialCharacters(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    final hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasSpecialCharacters;
  }

  static bool isPasswordMinLength(String password, [int minLength = 8]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    final hasMinLength = password.length > minLength;
    return hasMinLength;
  }

  //Encrypt data by Fernet
  static String encData(String str) {

    final key = Key.fromUtf8(ENC_KEY);
    print(key.bytes);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    // final b64key = Key.fromBase64(ENC_KEY);
    // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
    // final fernet = Fernet(b64key);
    final fernet = Fernet(key);
    final encrypter = Encrypter(fernet);
    final encrypted = encrypter.encrypt(str);
    return encrypted.base64;
  }

  //Decrypt data by Fernet
  static String decData(String str) {
    final key = Key.fromUtf8(ENC_KEY);

    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
    // final fernet = Fernet(b64key);
    final fernet = Fernet(key);
    final encrypter = Encrypter(fernet);
    final decrypted = encrypter.decrypt(Encrypted.from64(str));
    return decrypted;
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static Future<String> getDeviceDetails() async {
    String identifier;
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        final data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return identifier;
  }

  static Future<String> getDeviceToken() async {
    final firebaseWrapper = sl<FirebaseWrapper>();
    return firebaseWrapper?.tokenLocal ?? '';
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<Items> reduceListItemPersonalizeRecent(List<Items> data) {
    if (data == null || data.isEmpty) {
      return data;
    }
    final items = <Items>[];
    data.sort((a, b) {
      if (a.id == b.id) {
        return 0;
      }
      return a.id > b.id ? 1 : -1;
    });
    data.reduce((value, element) {
      if (value.id != element.id) {
        items.add(value);
      }
      return element;
    });
    items.add(data.last);
    return items;
  }

  static String etaWalkingTime(double distance) {
    distance = distance * 1000;
    final timeInMins = (distance * 60) / 5000;
    if (timeInMins < 1) {
      final minValue = (timeInMins * 100).round();
      return '$minValue ${minValue == 1 ? Lang.util_sec_one.tr() : Lang.util_sec_more.tr()}';
    } else if (timeInMins <= 30) {
      return '${timeInMins.round()} ${timeInMins.round() == 1 ? Lang.util_min_one.tr() : Lang.util_min_more.tr()}';
    }
    return null;
  }

  static String etaWalkingTimeCar(double distance) {
    distance = distance * 1000;
    final timeInMins = (distance * 60) / 40000;
    if (timeInMins < 1) {
      final minValue = (timeInMins * 100).round();
      return '$minValue ${minValue == 1 ? Lang.util_sec_one.tr() : Lang.util_sec_more.tr()}';
    } else if (timeInMins < 60) {
      return '${timeInMins.round()} ${timeInMins.round() == 1 ? Lang.util_min_one.tr() : Lang.util_min_more.tr()}';
    } else {
      final timeInHour = timeInMins / 60;
      if (timeInHour < 24) {
        return '${timeInHour.round()} ${timeInHour.round() == 1 ? Lang.util_hr_one.tr() : Lang.util_hr_more.tr()}';
      } else {
        final timeInDay = timeInHour / 24;
        if (timeInDay < 365) {
          return '${timeInDay.round()} ${timeInDay.round() == 1 ? Lang.util_day_one.tr() : Lang.util_day_more.tr()}';
        } else {
          final timeInYear = timeInDay / 365;
          return '${timeInYear.round()} ${timeInYear.round() == 1 ? Lang.util_yr_one.tr() : Lang.util_yr_more.tr()}';
        }
      }
    }
  }

  static void shareContent(String itemName, String url) {
    Share.share(Lang.sharing_check_out_name_on_hudayriyat_island_app
        .tr(args: [itemName, url]));
  }
}
