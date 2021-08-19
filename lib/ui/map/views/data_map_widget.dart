import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/container_widget.dart';
import '../../../common/widget/search_empty_widget.dart';
import '../../../data/model/amenity_model.dart';
import '../../../data/model/events.dart';
import '../../../data/model/places_model.dart';
import '../../../data/source/api_end_point.dart';
import '../../../utils/navigate_util.dart';
import '../../assets/asset_detail/asset_detail_page.dart';
import '../../event/detail/event_detail_page.dart';
import '../bloc/map_page_bloc.dart';
import 'widgets/card_search.dart';
import 'widgets/map_search_result.dart';
import 'widgets/single_card.dart';

class DataMapWidget extends StatefulWidget {
  final MapPageBloc bloc;
  final BoxConstraints constraints;
  final double paddingBottom;
  final Function zoomToMyLocation;
  final TextEditingController controllerSearch;

  const DataMapWidget(
      {Key key,
      this.bloc,
      this.controllerSearch,
      this.constraints,
      this.paddingBottom,
      this.zoomToMyLocation})
      : super(key: key);
  @override
  _DataMapWidgetState createState() => _DataMapWidgetState();
}

class _DataMapWidgetState extends State<DataMapWidget> {
  final GlobalKey slidingUpPanelKey = GlobalKey();
  final ValueNotifier<ModeViewDataMap> valueIsHorizontal =
      ValueNotifier(ModeViewDataMap.VERTICAL_LIST);
  ValueNotifier<double> fabHeight;
  double _initFabHeight = sizeImageNormalxx;
  double _slideMaxHeight = 0;

  @override
  void initState() {
    super.initState();

    _slideMaxHeight = widget.constraints.maxHeight - sizeImageLarge;
    _initFabHeight =
        widget.constraints.maxHeight * 0.3 + sizeExLarge + widget.paddingBottom;
    fabHeight = ValueNotifier(_initFabHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<ModeViewDataMap>(
          valueListenable: valueIsHorizontal,
          builder: (context, mode, snapshot) {
            ///Force Mode
            if (widget.bloc.state.markerSelected != null) {
              mode = ModeViewDataMap.SINGLE;
            }

            switch (mode) {
              case ModeViewDataMap.VERTICAL_LIST:
                return buildSlidingUpPanel(
                    widget.constraints, widget.bloc.state);
              case ModeViewDataMap.HORIZONTAL_LIST:
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: sizeExLarge + widget.paddingBottom),
                        height: widget.constraints.maxHeight * 0.3,
                        child: ListView.builder(
                          itemCount: widget.bloc.state.amenities?.length ?? 0,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: sizeNormal),
                          itemBuilder: (ctx, index) => Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: sizeNormal),
                              child: GestureDetector(
                                onTap: () {
                                  detectItemToSwitch(
                                      widget.bloc.state.amenities[index]);
                                },
                                child: CardSearch(
                                  data: widget.bloc.state.amenities[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              case ModeViewDataMap.SINGLE:
              default:
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(sizeNormal),
                        topRight: Radius.circular(sizeNormal)),
                    child: GestureDetector(
                      onTap: () {
                        detectItemToSwitch(
                            widget.bloc.state.markerSelected.amenityModel);
                      },
                      child: Container(
                        width: widget.constraints.maxWidth,
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            bottom: sizeExLarge + widget.paddingBottom),
                        height: widget.constraints.maxHeight * 0.4,
                        child: SingleCard(
                            data:
                                widget.bloc.state.markerSelected.amenityModel),
                      ),
                    ),
                  ),
                );
            }
          },
        ),
        ValueListenableBuilder<double>(
            valueListenable: fabHeight,
            builder: (context, value, snapshot) {
              return Positioned(
                right: sizeSmall,
                bottom: value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: sizeNormal),
                  child: Column(
                    children: [
                      ContainerWidget.circleButton(
                        color: Colors.white,
                        onTap: widget.zoomToMyLocation,
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(
                        height: sizeSmall,
                      ),
                      ContainerWidget.circleButton(
                        onTap: () {
                          widget.bloc.add(UnSelectMarker());
                          valueIsHorizontal.value = valueIsHorizontal.value ==
                                  ModeViewDataMap.HORIZONTAL_LIST
                              ? ModeViewDataMap.VERTICAL_LIST
                              : ModeViewDataMap.HORIZONTAL_LIST;
                          if (valueIsHorizontal.value ==
                              ModeViewDataMap.HORIZONTAL_LIST) {
                            fabHeight.value = _initFabHeight;
                          }
                        },
                        child: SvgPicture.asset(
                          IconConstants.horizontal,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget buildSlidingUpPanel(BoxConstraints constraints, MapPageState state) {
    return SlidingUpPanel(
      borderRadius: ThemeDecoration.sizeSmallxxx_LT,
      onPanelSlide: (double pos) {
        fabHeight.value =
            pos * (_slideMaxHeight - _initFabHeight) + _initFabHeight;
      },
      minHeight: _initFabHeight,
      maxHeight: _slideMaxHeight,
      panelBuilder: (ScrollController sc) => Padding(
        padding: const EdgeInsets.only(bottom: sizeLargexx),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: sizeSmall),
              child: SizedBoxWidget.divider(width: constraints.maxWidth),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.amenities?.isEmpty ?? true)
                      SearchEmptyWidget(
                        justInformEmpty: widget.controllerSearch.text.isEmpty,
                        keyWord: widget.controllerSearch.text.isEmpty
                            ? Lang.home_sorry_we_could_not_find_anything.tr()
                            : widget.controllerSearch.text,
                      ),
                    if (state.amenities?.isNotEmpty ?? false)
                      MapSearchResultWidget(
                        constraints: widget.constraints,
                        onItemClick: (e) {
                          detectItemToSwitch(e);
                        },
                        amenities: state.amenities,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void detectItemToSwitch(AmenityModel e) {
    try {
      final parent = e.parent;
      switch (parent.type) {
        case PARAM_EVENT_DETAILS:
          openEventDetail(EventInfo.convertSearchModel(e));
          break;
        case PARAM_AMENITIES_DETAILS:
          openAssetDetail(PlaceModel.convertFromSearchModel(e));
          break;
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value});
  }

  void openEventDetail(EventInfo value) {
    NavigateUtil.openPage(context, EventDetailScreen.routeName,
        argument: {'data': value});
  }
}

enum ModeViewDataMap { VERTICAL_LIST, HORIZONTAL_LIST, SINGLE }
