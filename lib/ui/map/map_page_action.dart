part of 'map_page.dart';

extension MapPageAction on _MapScreenState {
  Future<Marker> Function(Cluster<Place> place) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            // cluster.items.forEach(LogUtils.d);
            Place place;
            if (cluster.items.first != null) {
              place = cluster.items.first;
              _mapBloc.add(OnSelectMarker(place: place));
            }
            try {
              final controller = await _controller?.future;
              await controller?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      double.tryParse(place.amenityModel.lat),
                      double.tryParse(place.amenityModel.long),
                    ),
                    zoom: MapConstants.zoomTapMarker,
                  ),
                ),
              );
            } catch (e) {
              print(e.toString());
            }
          },
          infoWindow: InfoWindow(
            title: cluster.markers?.first?.item?.shortTitle ?? '...',
            snippet: cluster.markers?.first?.item?.shortSnippet ?? '...',
          ),
          icon: await getBitmapByCate(cluster.items),
        );
      };

  Future<BitmapDescriptor> getBitmapByCate(Iterable<Place> places) async {
    var experId = 0;
    final group = groupBy(places, (e) {
      return experId = e?.amenityModel?.parent?.experience?.id ?? -1;
    });
    final diffCount = group?.length ?? 1;
    if (diffCount > 1 || places.isEmpty) {
      return bitmapDescriptorFromSvgAsset(context, IconConstants.markerAll);
    }
    final placeSelected = places.first;
    var sizeExtend = sizeSmallxxx;
    try {
      if (placeSelected != null &&
          placeSelected.amenityModel.id ==
              _mapBloc.state.markerSelected.amenityModel.id) {
        sizeExtend = sizeSmallxxx;
      } else {
        sizeExtend = 0;
      }
    } catch (ex) {
      print('laceSelected.amenityModel.id ' + ex.toString());
    }
    switch (experId) {
      case 0:
        return bitmapDescriptorFromSvgAsset(context, IconConstants.markerAll,
            extendSize: sizeExtend);
      case 22:
        return bitmapDescriptorFromSvgAsset(
            context, IconConstants.markerDiscover,
            extendSize: sizeExtend);
      case 19:
        return bitmapDescriptorFromSvgAsset(context, IconConstants.markerPlay,
            extendSize: sizeExtend);
      case 20:
        return bitmapDescriptorFromSvgAsset(context, IconConstants.markerEat,
            extendSize: sizeExtend);
      case 23:
        return bitmapDescriptorFromSvgAsset(context, IconConstants.markerEnjoy,
            extendSize: sizeExtend);
      case 21:
        return bitmapDescriptorFromSvgAsset(context, IconConstants.markerStay,
            extendSize: sizeExtend);
      default:
        return bitmapDescriptorFromSvgAsset(context, IconConstants.markerAll,
            extendSize: sizeExtend);
    }
  }

  void onSelectArea(AreaItem areaItem) {
    if (cameraPosition != null) {
      onSubmitSearchKeyword('',
          lat: cameraPosition.target.latitude,
          lng: cameraPosition.target.longitude,
          areaItem: areaItem);
    }
  }

  void onShowDialogExperiences(MapPageState state) {
    UIUtil.showDialogAnimation(
      hasDragDismiss: true,
      child: ExperiencesDialog(
        listArea: state.listExperiences,
        areaSelected: state.currentExperience,
        onSelectArea: onSelectArea,
      ),
      context: context,
    );
  }

  Future<void> onSubmitSearchKeyword(String keyWord,
      {double lat, double lng, AreaItem areaItem}) async {
    final controller = await _controller?.future;
    final zoom = await controller.getZoomLevel();
    currentScaleDistance = 156540.03392 *
        cos((lat ?? DEFAULT_LOCATION_LAT) * pi / 180) /
        pow(2, zoom);

    _mapBloc.add(SearchEvent(
      keyword: _controllerSearch.text,
      lat: lat ?? DEFAULT_LOCATION_LAT,
      long: lng ?? DEFAULT_LOCATION_LONG,
      areaItem: areaItem ?? _mapBloc.state.currentExperience,
      distances: currentScaleDistance,
    ));
  }

  void onClearSearch() {
    _controllerSearch.clear();
    _searchFocusNode.unfocus();
    onMapIdle();
  }
}
