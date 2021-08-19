import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/di/injection/injector.dart';
import '../../common/widget/navigation_bottom.dart';
import '../../utils/app_const.dart';
import '../base/base_widget.dart';
import '../event/base/event_page.dart';
import '../home/home_page.dart';
import '../map/coming_soon/coming_soon_page.dart';
import '../map/map_page.dart';
import '../profile/profile_page.dart';
import 'bloc/main_bloc.dart';

class MainScreen extends BaseWidget {
  static const routeName = 'MainScreen';

  MainScreen();

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends BaseState<MainScreen> {
  final List<Widget> _listNavigateWidgets = <Widget>[];
  final MainBloc _mainBloc = sl<MainBloc>();
  int indexStack = 0;

  @override
  void initState() {
    initBasicInfo();
    super.initState();
  }

  void initBasicInfo() {
    _mainBloc.listen((state) {
      if (state is MainState) {}
    });
    _listNavigateWidgets.addAll([
      HomePage(
        onClickSeeAllEvent: openEventPage,
      ),
     MapScreen() ,
      EventScreen(),
      ProfilePage()
    ]);
  }

  void openEventPage() {
    _mainBloc.add(OnTabEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                IndexedStack(
                  index: state.currentTab,
                  children: _listNavigateWidgets,
                ),
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: NavigationBottom(
                        mainBloc: _mainBloc,
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mainBloc.close();
    super.dispose();
  }
}
