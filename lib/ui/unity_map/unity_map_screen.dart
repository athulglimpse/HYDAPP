import 'dart:async';
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:location/location.dart';
import 'package:marvista/ui/map/map_page.dart';

import '../../common/di/injection/injector.dart';
import '../../common/dialog/experiences_dialog.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/area_item.dart';
import '../../data/model/unity/unity_response_data.dart';
import '../../utils/app_const.dart';
import '../../utils/location_wrapper.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../../utils/unity_wrapper.dart';
import '../base/base_widget.dart';
import 'bloc/unity_map_bloc.dart';

class UnityMapScreen extends BaseWidget {
  static const routeName = 'UnityMapScreen';
  final double distance;
  UnityMapScreen({
    this.distance = DEFAULT_DISTANCE,
  });

  @override
  State<StatefulWidget> createState() {
    return UnityMapScreenState();
  }
}

class UnityMapScreenState extends BaseState<UnityMapScreen>
    with AfterLayoutMixin {
  final ValueNotifier<bool> valueCloseButton = ValueNotifier(false);

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  final _unity_mapBloc = sl<UnityMapBloc>();
  final locationWrapper = sl<LocationWrapper>();
  StreamController<LocationData> streamController = StreamController();
  StreamController<String> streamUnityData = StreamController();
  LocationData locationData;
  bool unityLoaded = false;
  bool unityDataAttached = false;
  bool isClosing = false;
  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
    locationWrapper.addListener(streamController);
    streamController.stream.listen((data) {
      locationData = data;
      updateLocationData();
    });

    streamUnityData.stream.listen((jsonResponse) {
      try {
        print(jsonResponse);
        final unityResponseData =
            UnityResponseData.fromJson(json.decode(jsonResponse));
        if (unityResponseData != null) {
          switch (unityResponseData.responseCode) {
            case 'GuideDirection':
              final dataJson = unityResponseData.data.replaceAll('\"', '"');

              final locationResponse =
                  LocationResponse.fromJson(json.decode(dataJson));
              _unity_mapBloc
                  .add(OpenGuideDirection(locationResponse, locationData));
              break;
            case 'StopGuideDirection':
              _unity_mapBloc.add(CloseDirection());
              break;
            default:
          }
        }
      } catch (e) {
        print('Cast Error :' + e?.toString() ?? '');
      }
    });
  }

  void initBasicInfo() {
    _unity_mapBloc.listen((state) async {
      await attachDataToUnity(state);

      if (state.directionRequest != null &&
          unityLoaded &&
          state.findDirection) {
        UnityWrapper.sendDirectionData(_unityWidgetController,
            json.encode(state.directionRequest.toJson()));
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    initLocationService();
  }

  Future<void> attachDataToUnity(UnityMapState state) async {
    if ((state.needUpdateUnity ?? false) && unityLoaded) {
      sendData(json.encode(state.amenities));
      if (!unityDataAttached) {
        unityDataAttached = true;
        await Future.delayed(const Duration(milliseconds: 2000));
        UnityWrapper.openMainARLocation(_unityWidgetController);
        await Future.delayed(const Duration(milliseconds: 1000));
        valueCloseButton.value = true;
      }
    }
  }

  Future<void> initLocationService() async {
    final hasPermission = await locationWrapper.requestPermission();
    if (!hasPermission) {
      return;
    }
    locationData = await locationWrapper.locationData();
    updateLocationData();
  }

  void updateLocationData() {
    if (locationData != null) {
      _unity_mapBloc.add(LocationChangeEvent(
          lat: locationData.latitude,
          long: locationData.longitude,
          distance: widget.distance,
          keyword: ''));
    } else {
      _unity_mapBloc.add(LocationChangeEvent(
          lat: DEFAULT_LOCATION_LAT,
          long: DEFAULT_LOCATION_LONG,
          distance: widget.distance,
          keyword: ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            if (valueCloseButton.value) {
              if (!isClosing) {
                isClosing = true;
                await closeUnity();
                return Future(() => false);
              } else {
                return Future(() => false);
              }
            }
            return Future(() => false);
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return BlocProvider(
              create: (_) => _unity_mapBloc,
              child: BlocBuilder<UnityMapBloc, UnityMapState>(
                  builder: (context, state) {
                if (state is UnityMapState) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        child: UnityWidget(
                          onUnityCreated: onUnityCreated,
                          // isARScene: true,
                          onUnityMessage: onUnityMessage,
                          onUnitySceneLoaded: onUnitySceneLoaded,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(
                              left: sizeSmallxxx,
                              right: sizeSmallxxx,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    onShowDialogExperiences(state);
                                  },
                                  child: Row(
                                    children: [
                                      UIUtil.makeCircleImageWidget(
                                          state.currentExperience?.icon,
                                          size: sizeNormal),
                                      const SizedBox(width: sizeVerySmall),
                                      MyTextView(
                                        text:
                                            state.currentExperience?.name ?? '',
                                        textStyle: textNormalxxx.copyWith(
                                            color: Colors.black,
                                            fontFamily:
                                                MyFontFamily.publicoBanner,
                                            fontWeight: MyFontWeight.bold),
                                      ),
                                      const SizedBox(width: sizeVerySmall),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: sizeNormalx,
                                      ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder<bool>(
                                    valueListenable: valueCloseButton,
                                    builder: (context, value, snapshot) {
                                      if (value) {
                                        return GestureDetector(
                                          onTap: () async {
                                            valueCloseButton.value = false;
                                            await closeUnity();
                                          },
                                          child: Material(
                                            color: Colors.white,
                                            type: MaterialType.circle,
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  sizeSmallx),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: sizeNormal,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
            );
          }),
        ),
      ),
    );
  }

  void onShowDialogExperiences(UnityMapState state) {
    UIUtil.showDialogAnimation(
      child: ExperiencesDialog(
        listArea: state.listExperiences,
        areaSelected: state.currentExperience,
        onSelectArea: onSelectArea,
      ),
      context: context,
    );
  }

  void onSelectArea(AreaItem v) {
    if (locationData != null) {
      _unity_mapBloc.add(SelectExperience(
          lat: locationData.latitude,
          long: locationData.longitude,
          distance: widget.distance,
          areaItem: v,
          keyword: ''));
    }
  }

  Future<void> closeUnity() async {
    UnityWrapper.openSplashScreen(_unityWidgetController);
    await Future.delayed(const Duration(milliseconds: 1000));
    NavigateUtil.pop(context);
  }

  @override
  void dispose() {
    streamUnityData.close();
    streamController.close();
    _unity_mapBloc.close();
    super.dispose();
  }

  /// Callback that connects the created controller to the unity controller
  void onUnityCreated(UnityWidgetController controller) {
    print("unityLoaded " + unityLoaded.toString());
    unityLoaded = true;
    _unityWidgetController = controller;
  }

  void sendData(String json) {
    _unityWidgetController.postMessage(
      'UnityMessageManager',
      'InitLocationData',
      json,
    );
  }

  void onUnityMessage(dynamic jsonResponse) {
    if (!(jsonResponse is String)) {
      return;
    }

    streamUnityData.sink.add(jsonResponse);
    print('Received message from unity: ${jsonResponse.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded scene) {
    print('Received scene loaded from unity: ${scene.name}');
    print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    if (!unityDataAttached) {
      attachDataToUnity(_unity_mapBloc.state);
    }
  }
}
