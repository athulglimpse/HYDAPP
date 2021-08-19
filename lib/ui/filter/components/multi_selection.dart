import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/area_item.dart';
import '../../../utils/ui_util.dart';

class MultiSelectionView extends StatelessWidget {
  final FilterArea itemFilter;
  final Function(FilterArea, FilterItem) onSelectItem;
  final Function(FilterArea) onClearMultiSelection;
  final Map<int, FilterItem> itemSelected;

  const MultiSelectionView({
    Key key,
    this.itemFilter,
    this.onSelectItem,
    this.itemSelected,
    this.onClearMultiSelection,
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
                  text: itemFilter?.name??''),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                onTap: () {
                  onClearMultiSelection(itemFilter);
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemFilter.filterItem.length,
          itemBuilder: (BuildContext context, int index) {
            return renderItem(context, index, itemFilter.filterItem);
          },
        ),
      ],
    );
  }

  Widget renderItem(
      BuildContext context, int index, List<FilterItem> filterItem) {
    final item = filterItem[index];
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          onSelectItem(itemFilter, item);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: sizeSmallxx, vertical: sizeSmallx),
          margin: const EdgeInsets.symmetric(
              horizontal: sizeSmallxxx, vertical: sizeSmall),
          decoration: BoxDecoration(
              boxShadow: [
                (itemSelected != null && itemSelected.containsKey(item.id))
                    ? const BoxShadow(
                        color: Color(0xffFDCB6B),
                        spreadRadius: 2,
                        blurRadius: 1,
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  UIUtil.makeCircleImageWidget(item.icon, size: sizeNormalxx),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: sizeSmall),
                    child: MyTextView(
                        text: item.name,
                        textStyle: textSmallxx.copyWith(
                            color: Colors.black, fontFamily: Fonts.Helvetica)),
                  ),
                ],
              ),
              (itemSelected != null && itemSelected.containsKey(item.id))
                  ? const Icon(
                      Icons.check_circle,
                      color: Color(0xff185d30),
                      size: sizeNormal,
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
