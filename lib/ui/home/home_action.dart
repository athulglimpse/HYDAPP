part of 'home_page.dart';

extension HomeAction on _HomePageState {
  void onShowDialogArea(HomeState state) {
    UIUtil.showDialogAnimation(
        hasDragDismiss: true,
        child: ExperiencesDialog(
          listArea: state.listAreas,
          areaSelected: state.currentArea,
          onSelectArea: onSelectArea,
        ),
        context: context);
  }

  void openDialogFacilities(HomeState state) {
    final listFilter = state.currentArea.filter;
    if (listFilter == null || listFilter.isEmpty) {
      return;
    }
    final currentFilter = listFilter[0];

    state.currentArea.id == 0
        ? UIUtil.showDialogAnimation(
                hasDragDismiss: true,
                child: FilterToolDialog(
                  filterArea: currentFilter,
                ),
                context: context)
            .then((value) {
            if (value != null && (value as Map).containsKey('data')) {
              final Map<int, bool> values = value['data'];
              if (values != null) {
                values.forEach((key, value) {
                  currentFilter.filterItem.forEach((e) {
                    if (key == e.id) {
                      e.selected = value;
                    }
                    _homeBloc.add(SelectFacility());
                    refreshController.requestRefresh(
                        needMove: true,
                        duration: const Duration(milliseconds: 500));
                  });
                });
              }
            }
          })
        : NavigateUtil.openPage(context, FilterPage.routeName, argument: {
            RouteArgument.currentArea: state.currentArea,
            'filter': state.filterOptSelected
          }).then((value) {
            if (value != null && value is Map) {
              print(value);
              _homeBloc.add(OnApplyFilter(value));
              refreshController.requestRefresh(
                  needMove: true, duration: const Duration(milliseconds: 500));
            }
          });
  }

  void onSelectArea(AreaItem v) {
    if (_homeBloc.state.currentArea.id != v.id) {
      if(v.isSingle != null && v.isSingle.isNotEmpty && v.isSingle == '1'){
        refreshController.requestRefresh(
            needMove: true, duration: const Duration(milliseconds: 500));
        _homeBloc.add(EnterDetail(v));
      }else{
        refreshController.requestRefresh(
            needMove: true, duration: const Duration(milliseconds: 500));
        if (_homeSearchBloc.state is HomeSearchSuccess) {
          _homeSearchBloc.add(SelectExperienceSearch(experienceId: v.id));
        }

        _homeBloc.add(SelectExperience(v));
      }
    }
  }

  void onSubmitSearchKeyword(String keyword) {
    if (keyword.isNotEmpty) {
      _searchFocusNode.unfocus();
      _homeSearchBloc.add(SearchkeyWordEvent(keyword: keyword));
    }
  }

  void onClickSeeAllList() {
    NavigateUtil.openPage(context, AssetSeeAllListScreen.routeName, argument: {
      'type': ViewAssetType.TRENDING_THIS_WEEK,
      'facilitesId': _homeBloc.state?.facilitesId,
      'experId': _homeBloc.state?.currentArea?.id ?? '',
      'filterAdv': _homeBloc.state?.filterOptSelected,
    });
  }

  void onClickSeeAllGrid(ViewAssetType viewAssetType) {
    NavigateUtil.openPage(context, AssetSeeAllGridScreen.routeName, argument: {
      'type': viewAssetType,
      'experId': _homeBloc.state?.currentArea?.id ?? '',
      'facilitesId': _homeBloc.state?.facilitesId,
      'filterAdv': _homeBloc.state?.filterOptSelected,
    });
  }

  void openSeeAllCommunity() {
    NavigateUtil.openPage(context, CommunitySeeAllScreen.routeName, argument: {
      'experId': _homeBloc.state?.currentArea?.id ?? '',
    });
  }

  void openSeeAllActivities() {
    NavigateUtil.openPage(context, WeekendActivitySeeAllScreen.routeName,
        argument: {
          'experId': _homeBloc.state?.currentArea?.id ?? '',
          'filterAdv': _homeBloc.state?.filterOptSelected,
        });
  }

  void openCommunityDetail(CommunityPost value) {
    NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      _homeBloc.add(FetchListCommunity());
    });
  }

  void addPostToFav(CommunityPost value) {
    if (_baseBloc.state.userInfo.isUser()) {
      _homeBloc.add(AddPostFavorite(value));
    } else {
      NavigateUtil.openPage(context, LoginPage.routeName);
    }
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      _homeBloc.add(FetchListCommunity());
    });
  }

  void openEventDetail(EventInfo value) {
    NavigateUtil.openPage(context, EventDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      if (value != null && (value as Map).containsKey('initRefresh')) {
        refreshController.requestRefresh(
            needMove: false, duration: const Duration(milliseconds: 300));
      }
    });
  }

  void checkPermissionCamera() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) =>
            CupertinoPickerPhotoView(onSelectPhoto: onSelectPhoto));
  }

  void onWriteReview() {
    NavigateUtil.openPage(context, CommunityWriteReviewPage.routeName);
  }

  void onSelectPhoto(String path) {
    NavigateUtil.openPage(context, CommunityPostPhotoPage.routeName,
        argument: {'path': path});
  }

  void onRemoveEvent(EventInfo value) {
    _homeBloc.add(RemoveEvent(value.id.toString()));
  }

  void onTurnOffEvent(EventInfo value) {
    _homeBloc.add(TurnOffEvent(value.id.toString()));
  }
}
