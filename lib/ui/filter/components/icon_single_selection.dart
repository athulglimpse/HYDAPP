import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/area_item.dart';
import '../../../utils/ui_util.dart';

class IconSingleSelectionView extends StatelessWidget {
  final FilterArea itemFilter;
  final Function(FilterArea, FilterItem) onSelectItem;
  final Function(FilterArea) onClearSelection;
  final FilterItem itemSelected;

  const IconSingleSelectionView({
    Key key,
    this.itemFilter,
    this.onSelectItem,
    this.itemSelected,
    this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  text: itemFilter?.name ?? ''),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                onTap: () {
                  onClearSelection(itemFilter);
                },
                textStyle: textSmallx.copyWith(
                    color: const Color(0xff419c9b),
                    fontWeight: FontWeight.bold),
                text: Lang.home_clear.tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: sizeNormal),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: itemFilter.filterItem
              .asMap()
              .map((index, value) => MapEntry(
                  index, renderItem(context, index, itemFilter.filterItem)))
              .values
              .toList(),
        ),
      ],
    );
  }

  Widget renderItem(
      BuildContext context, int index, List<FilterItem> filterItem) {
    final item = filterItem[index];
    print(item.icon);
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          onSelectItem(itemFilter, item);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      (itemSelected != null && itemSelected == item)
                          ? const BoxShadow(
                              color: Color(0xffFDCB6B),
                              spreadRadius: 2,
                              blurRadius: 1,
                            )
                          : BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: const Offset(
                                  0, 0.5), // changes position of shadow
                            ),
                    ],
                    color: (itemSelected != null && itemSelected == item)
                        ? const Color(0xffFDCB6B)
                        : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(sizeSmallxxx),
                    child: SizedBox(
                      width: sizeNormal,
                      height: sizeNormal,
                      child: UIUtil.makeImageWidget(
                        item.icon,
                        color: (itemSelected != null && itemSelected == item)
                            ? Colors.white
                            : Colors.grey,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: sizeSmall,
                    vertical: sizeSmall,
                  ),
                  child: MyTextView(
                      text: item.name,
                      textStyle: textSmallxx.copyWith(
                          color: (itemSelected != null && itemSelected == item)
                              ? const Color(0xffFDCB6B)
                              : Colors.grey,
                          fontFamily: Fonts.Helvetica)),
                ),
              ],
            ),
            // (itemSelected != null && itemSelected == item)
            //     ? const Icon(
            //         Icons.check_circle,
            //         color: Color(0xff185d30),
            //         size: sizeNormal,
            //       )
            //     : const SizedBox()
          ],
        ),
      ),
    );
  }
}
