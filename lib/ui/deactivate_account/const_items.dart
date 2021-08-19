import 'package:easy_localization/easy_localization.dart';

import '../../common/localization/lang.dart';
import '../../data/model/more_item.dart';

final List<MoreItem> constMoreItems = [
  MoreItem.fromJson({
    'name': Lang.deactivate_account_this_is_temporary,
    'id': '1',
  }),
  MoreItem.fromJson({
    'name': Lang.deactivate_account_my_account_was_hacked,
    'id': '2',
  }),
  MoreItem.fromJson({
    'name': Lang.deactivate_account_have_privacy_concern,
    'id': '3',
  }),
  MoreItem.fromJson({
    'name': Lang.deactivate_account_find_it_useful,
    'id': '4',
  }),
  MoreItem.fromJson({
    'name': Lang.deactivate_account_have_another_account,
    'id': '5',
  }),
  MoreItem.fromJson({
    'name': Lang.deactivate_account_please_explain_further,
    'id': '6',
  })
];
