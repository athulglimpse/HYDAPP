part of '../map_page.dart';

extension MapPageWidgetChild on _MapScreenState {
  Widget _getClearButton(MapPageState state) {
    return _searchFocusNode.hasFocus
        ? GestureButton.icon(
            Icons.clear,
            color: Colors.black,
            size: sizeNormal,
            onTap: onClearSearch,
          )
        : const SizedBox();
  }

  Widget _getSearchButton(MapPageState state) => GestureButton.icon(
        Icons.search,
        color: Colors.black,
        size: sizeNormal,
        onTap: () {
          print("  lat: cameraPosition.target.latitude, ");
          onSubmitSearchKeyword(
            _controllerSearch.text,
            lat: cameraPosition.target.latitude,
            lng: cameraPosition.target.longitude,
          );
        },
      );

  Padding _buildInputSearch(MapPageState state) {
    return Padding(
      padding: const EdgeInsets.only(
          left: sizeSmallxxx, right: sizeSmallxxx, top: sizeNormal),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: sizeLargex,
              child: InputFieldRect(
                controller: _controllerSearch,
                focusNode: _searchFocusNode,
                onSubmit: (v) {
                  onSubmitSearchKeyword(
                    v,
                    lat: cameraPosition.target.latitude,
                    lng: cameraPosition.target.longitude,
                  );
                },
                cusPreIcon: _getSearchButton(state),
                cusSubIcon: _getClearButton(state),
                textAlign: TextAlign.start,
                hintStyle: textSmallx.copyWith(
                    color: const Color(0xffb9b9b9),
                    fontWeight: MyFontWeight.regular),
                borderColor: Colors.transparent,
                borderRadius: sizeSmall,
                textStyle: textSmallx.copyWith(color: Colors.black),
                hintText: Lang.home_looking_for_something.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
