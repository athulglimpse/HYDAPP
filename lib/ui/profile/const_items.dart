import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marvista/utils/app_const.dart';
import '../../common/constants.dart';

import '../../common/localization/lang.dart';
import '../../data/model/more_item.dart';

final List<MoreItem> constMoreItemsForGuest = [
  MoreItem.fromJson({
    'name': Lang.more_settings,
    'id': '4',
    'image': Res.profile_icon_settings,
  }),
  MoreItem.fromJson({
    'name': Lang.more_help,
    'id': '5',
    'image': Res.profile_icon_help,
  }),
];

final List<MoreItem> constMoreItems = [
  MoreItem.fromJson({
    'name': Lang.more_saved_items,
    'id': '2',
    'image': Res.profile_icon_saved_items,
  }),
  MoreItem.fromJson({
    'name': Lang.more_settings,
    'id': '4',
    'image': Res.profile_icon_settings,
  }),
  MoreItem.fromJson({
    'name': Lang.more_help,
    'id': '5',
    'image': Res.profile_icon_help,
  }),
  if (!isMVP)
    MoreItem.fromJson({
      'name': Lang.profile_post_and_review,
      'id': '6',
      'image': Res.profile_icon_saved_items,
    }),
  MoreItem.fromJson({
    'name': Lang.more_logout,
    'id': '7',
    'image': Res.logout_icon_help,
  }),
];
