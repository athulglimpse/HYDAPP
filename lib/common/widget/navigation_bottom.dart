import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../ui/main/bloc/main_bloc.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class NavigationBottom extends StatefulWidget {
  final MainBloc mainBloc;

  const NavigationBottom({
    Key key,
    this.mainBloc,
  }) : super(key: key);

  @override
  _NavigationBottomState createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  MainBloc _mainBloc;

  @override
  void initState() {
    _mainBloc = widget.mainBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFBBC43).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(sizeNormalxx),
          topRight: Radius.circular(sizeNormalxx),
        ),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + sizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _mainBloc.add(OnTabHome());
                },
                splashColor: const Color(0xffFBBC43).withAlpha(80),
                borderRadius: BorderRadius.circular(sizeNormal),
                child: _mainBloc.state.currentTab != TAB_HOME
                    ? Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: UIUtil.makeImageWidget(
                          Res.icon_home,
                          color: Colors.grey[700],
                          size: const Size(sizeNormalx, sizeNormalx),
                          boxFit: BoxFit.contain,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextView(
                              text: Lang.navigate_home.tr(),
                              textStyle: textSmallx.copyWith(
                                  color: const Color(0xffFBBC43)),
                            ),
                            const SizedBox(
                              height: sizeVerySmall,
                            ),
                            const ClipOval(
                              child: Material(
                                color: Color(0xffFBBC43), // button color
                                child: SizedBox(
                                  width: sizeVerySmall,
                                  height: sizeVerySmall,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _mainBloc.add(OnTabMap()),
                splashColor: const Color(0xffFBBC43).withAlpha(80),
                borderRadius: BorderRadius.circular(sizeNormal),
                child: _mainBloc.state.currentTab != TAB_MAP
                    ? Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: UIUtil.makeImageWidget(
                          Res.icon_maps,
                          color: Colors.grey[700],
                          size: const Size(sizeNormalx, sizeNormalx),
                          boxFit: BoxFit.contain,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextView(
                                text: Lang.navigate_maps.tr(),
                                textStyle: textSmallx.copyWith(
                                    color: const Color(0xffFBBC43))),
                            const SizedBox(
                              height: sizeVerySmall,
                            ),
                            const ClipOval(
                              child: Material(
                                color: Color(0xffFBBC43), // button color
                                child: SizedBox(
                                    width: sizeVerySmall,
                                    height: sizeVerySmall),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _mainBloc.add(OnTabEvent()),
                splashColor: const Color(0xffFBBC43).withAlpha(80),
                borderRadius: BorderRadius.circular(sizeNormal),
                child: _mainBloc.state.currentTab != TAB_EVENT
                    ? Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: UIUtil.makeImageWidget(Res.icon_event,
                            color: Colors.grey[700],
                            size: const Size(sizeNormalx, sizeNormalx),
                            boxFit: BoxFit.contain),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextView(
                                text: Lang.navigate_events.tr(),
                                textStyle: textSmallx.copyWith(
                                    color: const Color(0xffFBBC43))),
                            const SizedBox(
                              height: sizeVerySmall,
                            ),
                            const ClipOval(
                              child: Material(
                                color: Color(0xffFBBC43), // button color
                                child: SizedBox(
                                    width: sizeVerySmall,
                                    height: sizeVerySmall),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _mainBloc.add(OnTabSetting()),
                splashColor: const Color(0xffFBBC43).withAlpha(80),
                borderRadius: BorderRadius.circular(sizeNormal),
                child: _mainBloc.state.currentTab != TAB_SETTING
                    ? Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: UIUtil.makeImageWidget(Res.icon_more,
                            size: const Size(sizeNormalx, sizeNormalx),
                            boxFit: BoxFit.contain),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextView(
                              text: Lang.navigate_more.tr(),
                              textStyle: textSmallx.copyWith(
                                  color: const Color(0xffFBBC43)),
                            ),
                            const SizedBox(
                              height: sizeVerySmall,
                            ),
                            const ClipOval(
                              child: Material(
                                color: Color(0xffFBBC43), // button color
                                child: SizedBox(
                                    width: sizeVerySmall,
                                    height: sizeVerySmall),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
