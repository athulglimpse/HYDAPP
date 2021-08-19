import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/personalization_item.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../notification_setting/notification_setting_page.dart';
import 'bloc/bloc.dart';
import 'component/personalize_card_view.dart';
import 'component/personalize_child_card_view.dart';

class PersonalizationScreen extends BaseWidget {
  static const routeName = '/PersonalizationScreen';

  PersonalizationScreen();

  @override
  State<StatefulWidget> createState() {
    return PersonalizationScreenState();
  }
}

class PersonalizationScreenState extends BaseState<PersonalizationScreen> {
  final PersonalizationBloc _personalizationBloc = sl<PersonalizationBloc>();
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
  }

  void initBasicInfo() {
    _personalizationBloc.listen(onStateChange);
  }

  Future<void> onStateChange(PersonalizationState state) async {
    await _pbLoading.hide();
    if (state.submitSuccess) {
      await NavigateUtil.openPage(context, NotificationSettingScreen.routeName,
          argument: {'firstTime': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());

    return BlocProvider(
      create: (_) => _personalizationBloc,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_personalizationBloc.state.isChildScreen) {
              _personalizationBloc.add(OnClickBack());
              return Future(() => false);
            }
            return Future(() => false);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              leading: BlocBuilder<PersonalizationBloc, PersonalizationState>(
                builder: (context, state) {
                  return _personalizationBloc.state.isChildScreen
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black),
                          onPressed: () {
                            if (_personalizationBloc.state.isChildScreen) {
                              _personalizationBloc.add(OnClickBack());
                            }
                          },
                        )
                      : const SizedBox();
                },
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              title: MyTextView(
                textAlign: TextAlign.center,
                textStyle: textNormal.copyWith(color: Colors.black),
                text: Lang.pick_the_amenities.tr(),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: sizeImageNormal),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: sizeSmallxx,
                            left: sizeLargexxx,
                            right: sizeLargexxx),
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: MyTextView(
                          textStyle:
                              textSmallx.copyWith(color: Colors.grey[850]),
                          text: Lang.we_will_use_them.tr(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: BlocProvider(
                          create: (_) => _personalizationBloc,
                          child: BlocBuilder<PersonalizationBloc,
                              PersonalizationState>(
                            builder: (context, state) {
                              return state.isChildScreen
                                  ? buildChildPersonalizeScreen(context)
                                  : buildCatePersonalizeScreen(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  bottom: sizeLargexxx,
                  child: BlocBuilder<PersonalizationBloc, PersonalizationState>(
                    builder: (context, state) {
                      final countSelectedItem = state.personalizationItemList
                              ?.where((e) => e.selected)
                              ?.toList()
                              ?.length ??
                          0;
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: MyButton(
                          paddingHorizontal: sizeImageSmall,
                          text: state.isChildScreen
                              ? Lang.done.tr()
                              : ('${Lang.interest_next.tr()}'),
                          height: sizeLargexx,
                          minWidth: sizeImageLarge,
                          disable: state.isChildScreen
                              ? (state.groupChildSelectedId?.isEmpty ?? true)
                              : (countSelectedItem < 1),
                          disableColor: const Color(0xffA7A8BB),
                          onTap: () => onDone(_personalizationBloc.state),
                          isFillParent: false,
                          textStyle: textSmallxxx.copyWith(color: Colors.white),
                          buttonColor: const Color(0xff242655),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocProvider<PersonalizationBloc> buildChildPersonalizeScreen(
      BuildContext context) {
    return BlocProvider(
      create: (_) => _personalizationBloc,
      child: BlocBuilder<PersonalizationBloc, PersonalizationState>(
        builder: (context, state) {
          if (state.listChild == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          count = 0;
          return Container(
            margin: const EdgeInsets.only(
                top: sizeNormalx, right: sizeSmall, left: sizeSmall),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.99),
              itemCount: state.listChild.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (BuildContext context, int index) {
                final child = state.listChild[index];
                count++;
                // if (count == 3) {
                //   count = 0;
                // }
                return Center(
                  child: PersonalizationChildCardView(
                    index: count,
                    onSelectItem: onChildItem,
                    childPersonal: child,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  int count = 0;

  BlocProvider<PersonalizationBloc> buildCatePersonalizeScreen(
      BuildContext context) {
    return BlocProvider(
      create: (_) => _personalizationBloc,
      child: BlocBuilder<PersonalizationBloc, PersonalizationState>(
        builder: (context, state) {
          if (state.personalizationItemList == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            margin: const EdgeInsets.only(
                top: sizeNormalx, right: sizeSmall, left: sizeSmall),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.99),
              itemCount: state.personalizationItemList.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (BuildContext context, int index) {
                final personalizationItem =
                    state.personalizationItemList[index];
                return Center(
                  child: PersonalizationCardView(
                    index: index,
                    onSelectItem: onItem,
                    personalizationItem: personalizationItem,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _personalizationBloc.close();
    super.dispose();
  }

  void onItem(PersonalizationItem personalizationItem) {
    _personalizationBloc.add(OnSelectItem(personalizationItem));
  }

  void onChildItem(Items child) {
    _personalizationBloc.add(OnSelectChildItem(child));
  }

  void onDone(PersonalizationState state) {
      if (state.isChildScreen) {
        checkHasChildSelected(state);
      } else {
        _personalizationBloc.add(NextPhase());
      }
  }

  void checkHasChildSelected(PersonalizationState state) {
    if (state.groupChildSelectedId.isNotEmpty) {
      _pbLoading.show();
      _personalizationBloc.add(SubmitPersonalization());
    }
  }
}
