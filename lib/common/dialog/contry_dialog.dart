import 'package:flutter/material.dart';

import '../../data/model/country.dart';
import '../../utils/navigate_util.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class CountryDialog extends StatelessWidget {
  final List<Country> listCountry;
  final Function(Country) onSelectCountry;
  final Country countrySelected;

  const CountryDialog(
      {Key key, this.listCountry, this.onSelectCountry, this.countrySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listCountry.length,
              itemBuilder: (BuildContext context, int index) {
                return renderItemCountry(context, index, listCountry);
              },
            ),
          ),
        ],
      ),
      positionDialog: PositionDialog.center,
      insetMargin: const EdgeInsets.all(sizeLarge),
    );
  }

  Widget renderItemCountry(
      BuildContext context, int index, List<dynamic> arrMenu) {
    final Country item = arrMenu[index];
    return Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            NavigateUtil.pop(context);
            onSelectCountry(item);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: sizeSmallxxx, vertical: sizeSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: MyTextView(
                      textAlign: TextAlign.start,
                      // ignore: prefer_interpolation_to_compose_strings
                      text: item.name + '(' + item.dialCode + ')',
                      textStyle: textSmallxx.copyWith(
                          color: Colors.black, fontFamily: Fonts.Helvetica)),
                ),
                const SizedBox(width: sizeSmall),
                (countrySelected != null && countrySelected == item)
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: sizeSmallxxx,
                      )
                    : const SizedBox(width: sizeSmallxxx)
              ],
            ),
          ),
        ));
  }
}
