import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/dialog/experiences_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/gesture_button.dart';
import '../../common/widget/input_field_rect.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/area_item.dart';
import '../../utils/app_const.dart';
import '../../utils/assets_utils.dart';
import '../../utils/location_wrapper.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../unity_map/unity_map_screen.dart';
import 'bloc/map_page_bloc.dart';
import 'models/place.dart';
import 'views/data_map_widget.dart';

part 'map_constants.dart';

part 'map_page_action.dart';

part 'views/map_widget_child.dart';

class MapScreen extends BaseWidget {
  static const routeName = 'MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends BaseState<MapScreen> with AfterLayoutMixin {
  final _mapBloc = sl<MapPageBloc>();

  final locationWrapper = sl<LocationWrapper>();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _controllerSearch = TextEditingController();
  LocationData _locationData;
  double currentScaleDistance = DEFAULT_DISTANCE;
  final Completer<GoogleMapController> _controller = Completer();
  final StreamController<LocationData> _streamController = StreamController();
  CameraPosition cameraPosition;

  ClusterManager _manager;
  Map<String, BitmapDescriptor> bitmapDescriptor;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      _mapBloc.add(UnSelectMarker());
    });
    locationWrapper.addListener(_streamController);
    _streamController.stream.listen((location) {
      _locationData = location;
    });

    ///init Cluster
    _manager = ClusterManager<Place>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
      initialZoom: MapConstants.zoomMapDefault,
    );
    _mapBloc.manager = _manager;
  }

  void _updateMarkers(Set<Marker> marker) {
    _mapBloc.add(UpdateMarker(marker));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    initLocationService();
  }

  ///
  /// Reuqest user Location
  Future<void> initLocationService() async {
    // await locationWrapper.requestPermission();
    _locationData = await locationWrapper.locationData();

    await zoomToDefaultLocation();
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    _searchFocusNode.dispose();
    _mapBloc.close();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final paddingBottom = MediaQuery.of(context).viewPadding.bottom;
    return BlocProvider(
      create: (context) => _mapBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return BlocBuilder<MapPageBloc, MapPageState>(
              builder: (context, state) {
                if (state is MapPageError) {
                  return const SizedBox();
                } else {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        buildingsEnabled: false,
                        mapToolbarEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            _locationData?.latitude ??
                                DEFAULT_LOCATION_LAT,
                            _locationData?.longitude ??
                                DEFAULT_LOCATION_LONG,
                          ),
                          zoom: MapConstants.zoomMapDefault,
                        ),
                        markers: state.markers,
                        zoomControlsEnabled: false,
                        padding: EdgeInsets.only(
                            bottom: paddingBottom +
                                sizeNormal +
                                constraints.maxHeight * 0.4),
                        compassEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          _manager.setMapController(controller);
                          zoomToDefaultLocation();
                        },
                        onCameraMove: (cam) {
                          _manager.onCameraMove(cam);
                          cameraPosition = cam;
                        },
                        onCameraIdle: () {
                          _manager.updateMap();
                          onMapIdle();
                        },
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(
                              left: sizeSmallxxx,
                              right: sizeSmallxxx,
                            ),
                            decoration: ThemeDecoration.topScreen,
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

                                ///Navigation to unity map
                                // GestureDetector(
                                //   onTap: () {
                                //     UIUtil.checkPermissionCamera(context)
                                //         .then((value) => {
                                //               if (value)
                                //                 {
                                //                   NavigateUtil.openPage(context,
                                //                       UnityMapScreen.routeName)
                                //                 }
                                //             });
                                //   },
                                //   child: Material(
                                //     color: Colors.black,
                                //     type: MaterialType.circle,
                                //     child: UIUtil.makeImageWidget(
                                //         Res.icon_ar_map,
                                //         width: sizeLargex,
                                //         height: sizeLargex),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          _buildInputSearch(state),
                        ],
                      ),
                      DataMapWidget(
                        bloc: _mapBloc,
                        paddingBottom: paddingBottom,
                        controllerSearch: _controllerSearch,
                        constraints: constraints,
                        zoomToMyLocation: zoomToMyLocation,
                      ),
                    ],
                  );
                }
              },
            );
          }),
        ),
      ),
    );
  }

  void onMapIdle() {
    if (cameraPosition != null) {
      onSubmitSearchKeyword(
        '',
        lat: cameraPosition.target.latitude,
        lng: cameraPosition.target.longitude,
      );
    }
  }

  Future<void> zoomToDefaultLocation() async {
    if (_locationData != null) {
      final controller = await _controller?.future;
      await controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(DEFAULT_LOCATION_LAT, DEFAULT_LOCATION_LONG),
            zoom: MapConstants.zoomMapDefault,
          ),
        ),
      );
      onMapIdle();
    }
  }

  Future<void> zoomToMyLocation() async {
    if (_locationData != null) {
      final controller = await _controller?.future;
      await controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_locationData.latitude, _locationData.longitude),
            zoom: MapConstants.zoomMapDefault,
          ),
        ),
      );
      onMapIdle();
    }
  }
}
