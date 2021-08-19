import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marvista/ui/community/community_detail/community_detail_page.dart';
import 'package:uni_links/uni_links.dart';

import '../common/di/injection/injector.dart';
import '../data/model/user_info.dart';
import '../data/source/api_end_point.dart';
import '../ui/assets/asset_detail/asset_detail_page.dart';
import '../ui/base/bloc/base_bloc.dart';
import '../ui/event/detail/event_detail_page.dart';
import '../ui/main/main_page.dart';
import 'environment_info.dart';
import 'navigate_util.dart';
import 'ui_util.dart';

enum UniLinksType { string, uri }

class UniLinkWrapper {
  final EnvironmentInfo env = sl<EnvironmentInfo>();
  final baseBloc = sl<BaseBloc>();
  String _initialLink;
  Uri _initialUri;
  String _latestLink = 'Unknown';
  String get urlShareEn => '${env.host}/en/share?';
  String get urlShareAr => '${env.host}/ar/share?';
  final UniLinksType _type = UniLinksType.string;

  UniLinkWrapper();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  Future<void> initPlatformStateForStringUniLinks() async {
    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      _latestLink = link ?? 'Unknown';
      try {
        _initialLink = link;

        handleUri();
      } on FormatException {
        //todo
      }
      print('go link: $link');
    }, onError: (Object err) {
      _initialUri = null;
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      handleUri();
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      _initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      _initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    _latestLink = _initialLink;
  }

  void handleUri() {
    if (_initialLink != null) {
      _initialUri = Uri.parse(_initialLink);
      if ((_initialLink.contains(urlShareEn) ||
              _initialLink.contains(urlShareAr)) &&
          _initialUri != null) {
        baseBloc.add(OnAppLink(uri: _initialUri));
      }
    }
  }

  /// An implementation using the [Uri] convenience helpers
  Future<void> initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    getUriLinksStream().listen((Uri uri) {
      _latestLink = uri?.toString() ?? 'Unknown';
    }, onError: (Object err) {
      _latestLink = 'Failed to get latest link: $err.';
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      _initialUri = uri;
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest Uri
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialUri = await getInitialUri();
      print('initial uri: ${_initialUri?.path}'
          ' ${_initialUri?.queryParametersAll}');
      _initialLink = _initialUri?.toString();
    } on PlatformException {
      _initialUri = null;
      _initialLink = 'Failed to get initial uri.';
    } on FormatException {
      _initialUri = null;
      _initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    _latestLink = _initialLink;
  }

  String getLink() {
    return _latestLink;
  }

  Uri getUri() {
    return _initialUri;
  }

  static bool handleDirectLink({
    Uri uri,
    UserInfo userInfo,
    BuildContext context,
  }) {
    try {
      if (uri?.queryParameters?.containsKey('type') ?? false) {
        ///Check params
        final type = uri.queryParameters['type'];
        final id = uri.queryParameters.containsKey('id')
            ? uri.queryParameters['id']
            : '';

        ///check user has login
        if (userInfo == null ||
            (userInfo.isUser() && !userInfo.isActivated())) {
          return false;
        }
        switch (type) {
          case PARAM_AMENITIES_DETAILS:
            NavigateUtil.openPage(context, AssetDetailScreen.routeName,
                argument: {'id': id}).then((value) {
              NavigateUtil.replacePage(context, MainScreen.routeName);
            });
            return true;
          case PARAM_MY_POST:
          case PARAM_COMMUNITY_POST:
          case PARAM_COMMENT:
            NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
                argument: {'id': id}).then((value) {
              NavigateUtil.replacePage(context, MainScreen.routeName);
            });
            return true;
          case PARAM_EVENT_DETAILS:
            NavigateUtil.openPage(context, EventDetailScreen.routeName,
                argument: {'id': id}).then((value) {
              NavigateUtil.replacePage(context, MainScreen.routeName);
            });
            return true;
        }
      }
    } catch (e) {
      UIUtil.showToast('unknown url');
    }
    return false;
  }
}
