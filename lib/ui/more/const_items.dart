import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../common/localization/lang.dart';
import '../../data/model/more_item.dart';

final List<MoreItem> constMoreItemsForGuest = [
  MoreItem.fromJson({
    'name': Lang.more_saved_items.tr(),
    'id': '2',
    'image': Icons.turned_in_not_outlined
  }),
  MoreItem.fromJson({
    'name': Lang.more_parking_reminder.tr(),
    'id': '3',
    'image': Icons.person_pin_circle_outlined
  }),
  MoreItem.fromJson({
    'name': Lang.more_settings.tr(),
    'id': '4',
    'image': Icons.settings_outlined
  }),
  MoreItem.fromJson({
    'name': Lang.more_help.tr(),
    'id': '5',
    'image': Icons.adjust_outlined,
  }),
  MoreItem.fromJson({
    'name': Lang.more_connect_social_media.tr(),
    'id': '6',
    'image': Icons.language
  }),
  MoreItem.fromJson({
    'name': Lang.more_logout.tr(),
    'id': '7',
    'image': Icons.logout,
  }),
];

final List<MoreItem> constMoreItems = [
  MoreItem.fromJson({
    'name': Lang.more_profile.tr(),
    'id': '1',
    'image': Icons.account_circle_outlined
  }),
  ...constMoreItemsForGuest
];
