part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<AreaItem> listAreas;
  final AreaItem currentArea;
  final WeatherInfo weatherInfo;
  final String keyword;
  final double bottomFieldSearch;
  final List<ActivityModel> activities;
  final CommunityModel communityModel;
  final String facilitesId;
  final String timeRefresh;
  final String assetDetailId;
  final HomeRoute homeRoute;
  final AssetDetail assetDetail;
  final AppConfig appConfig;
  final EventDetailInfo eventDetailInfo;
  final Map<int, Map> filterOptSelected;

  final List<PlaceModel> listTrending;
  final List<PlaceModel> listTopRate;
  final List<PlaceModel> listMightLike;
  final List<PlaceModel> listRestaurants;
  final List<PlaceModel> listFacilities;
  final List<PlaceModel> listActivities;
  final List<PlaceModel> listFoodTrucks;

  final List<EventInfo> listEvents;

  HomeState({
    this.keyword,
    this.timeRefresh,
    this.assetDetail,
    this.eventDetailInfo,
    this.filterOptSelected,
    this.bottomFieldSearch,
    this.activities,
    this.homeRoute,
    this.assetDetailId,
    this.communityModel,
    this.listTrending,
    this.listMightLike,
    this.listTopRate,
    this.listRestaurants,
    this.listFacilities,
    this.listActivities,
    this.listEvents,
    this.listFoodTrucks,
    this.currentArea,
    this.facilitesId,
    this.appConfig,
    @required this.listAreas,
    @required this.weatherInfo,
  });

  ///init State with data cache if has
  factory HomeState.initial(
      HomeRepository homeRepository,
      UserRepository userRepository,
      EventRepository eventRepository,
      AssetRepository assetRepository,
      ConfigRepository configRepository) {
    final areas = homeRepository.getExperiences();
    userRepository.getCurrentUser();
    return HomeState(
      listAreas: areas,
      keyword: '',
      assetDetailId: '',
      communityModel: homeRepository.getCommunityListInfo(),
      listEvents: eventRepository.getEvents(),
      bottomFieldSearch: 0,
      homeRoute: HomeRoute.enterHomePage,
      appConfig: configRepository.getAppConfig(),
      facilitesId: null,
      assetDetail: null,
      activities: homeRepository.getActivities(),
      eventDetailInfo: null,
      currentArea: (areas != null && areas.isNotEmpty) ? areas[0] : null,
      weatherInfo: homeRepository.getWeatherInfo(),
      listMightLike: assetRepository.getAssets(ViewAssetType.MIGHT_LIKE),
      listTrending: assetRepository.getAssets(ViewAssetType.TRENDING_THIS_WEEK),
      listRestaurants: assetRepository.getAssets(ViewAssetType.RESTAURANTS),
      listFacilities: assetRepository.getAssets(ViewAssetType.FACILITIES),
      listActivities: assetRepository.getAssets(ViewAssetType.ACTIVITIES),
      listFoodTrucks: assetRepository.getAssets(ViewAssetType.FOOD_TRUCKS),
    );
  }

  HomeState copyWith({
    List<AreaItem> listAreas,
    WeatherInfo weatherInfo,
    AreaItem currentArea,
    String keyword,
    String timeRefresh,
    Map<int, Map> filterOptSelected,
    String assetDetailId,
    double bottomFieldSearch,
    bool isFocusFieldSearch,
    List<ActivityModel> activities,
    List<AmenityInfo> amenities,
    CommunityModel communityModel,
    AssetDetail assetDetail,
    EventDetailInfo eventDetailInfo,
    String facilitesId,
    HomeRoute homeRoute,
    List<EventInfo> listEvents,
    List<PlaceModel> listTrending,
    List<PlaceModel> listMightLike,
    List<PlaceModel> listTopRate,
    List<PlaceModel> listRestaurants,
    List<PlaceModel> listFacilities,
    List<PlaceModel> listActivities,
    List<PlaceModel> listFoodTrucks,
  }) {
    return HomeState(
      listAreas: listAreas ?? this.listAreas,
      timeRefresh: timeRefresh ?? this.timeRefresh,
      activities: activities ?? this.activities,
      assetDetailId: assetDetailId ?? this.assetDetailId,
      communityModel: communityModel ?? this.communityModel,
      facilitesId: facilitesId ?? this.facilitesId,
      filterOptSelected: filterOptSelected ?? this.filterOptSelected,
      listTrending: listTrending ?? this.listTrending,
      assetDetail: assetDetail ?? this.assetDetail,
      eventDetailInfo: eventDetailInfo ?? this.eventDetailInfo,
      homeRoute: homeRoute ?? this.homeRoute,
      listEvents: listEvents ?? this.listEvents,
      listMightLike: listMightLike ?? this.listMightLike,
      listTopRate: listTopRate ?? this.listTopRate,
      listRestaurants: listRestaurants ?? this.listRestaurants,
      listFacilities: listFacilities ?? this.listFacilities,
      listActivities: listActivities ?? this.listActivities,
      listFoodTrucks: listFoodTrucks ?? this.listFoodTrucks,
      currentArea: currentArea ?? this.currentArea,
      keyword: keyword ?? this.keyword,
      bottomFieldSearch: bottomFieldSearch ?? this.bottomFieldSearch,
      weatherInfo: weatherInfo ?? this.weatherInfo,
    );
  }

  HomeState addFacility({
    String facilitesId,
  }) {
    return HomeState(
      listAreas: listAreas,
      timeRefresh: timeRefresh,
      activities: activities,
      communityModel: communityModel,
      facilitesId: facilitesId,
      listTrending: listTrending,
      listEvents: listEvents,
      listMightLike: listMightLike,
      listTopRate: listTopRate,
      listRestaurants: listRestaurants,
      listFacilities: listFacilities,
      listActivities: listActivities,
      listFoodTrucks: listFoodTrucks,
      currentArea: currentArea,
      keyword: keyword,
      bottomFieldSearch: bottomFieldSearch,
      weatherInfo: weatherInfo,
    );
  }

  @override
  List<Object> get props => [
        listAreas,
        activities,
        listTrending,
        listTopRate,
        assetDetailId,
        listRestaurants,
        listTrending,
        listFacilities,
        listActivities,
        communityModel,
        eventDetailInfo,
        filterOptSelected,
        listMightLike,
        assetDetail,
        homeRoute,
        facilitesId,
        listEvents,
        listFoodTrucks,
        timeRefresh,
        currentArea,
        weatherInfo,
        keyword,
        bottomFieldSearch,
      ];

  @override
  String toString() {
    return '''HomeState {
      listAreas: $listAreas,
      activities: $activities,
      listRestaurants: $listRestaurants,
      listTrending: $listTrending,
      communityModel: $communityModel,
      assetDetail: $assetDetail,
      eventDetailInfo: $eventDetailInfo,
      homeRoute: $homeRoute,
      facilitesId: $facilitesId,
      listEvents: $listEvents,
      listFacilities: $listFacilities,
      currentArea: $currentArea,
      weatherInfo: $weatherInfo,
      keyword: $keyword,
      bottomFieldSearch: $bottomFieldSearch,
    }''';
  }
}

class LoadingSuccess extends HomeState {
  LoadingSuccess({HomeState state})
      : super(
          keyword: state.keyword,
          timeRefresh: state.timeRefresh,
          assetDetail: state.assetDetail,
          eventDetailInfo: state.eventDetailInfo,
          bottomFieldSearch: state.bottomFieldSearch,
          homeRoute: state.homeRoute,
          filterOptSelected: state.filterOptSelected,
          communityModel: state.communityModel,
          listTrending: state.listTrending,
          listRestaurants: state.listRestaurants,
          listFacilities: state.listFacilities,
          listActivities: state.listActivities,
          listFoodTrucks: state.listFoodTrucks,
          listEvents: state.listEvents,
          currentArea: state.currentArea,
          facilitesId: state.facilitesId,
          listAreas: state.listAreas,
          weatherInfo: state.weatherInfo,
        );
}

class LogoutSuccess extends HomeState {}

class LoadDataStoreError extends HomeState {
  final String msg;

  LoadDataStoreError(this.msg);
}

enum HomeRoute {
  enterHomePage,
  enterEventDetailPage,
  enterAssetDetailPage,
}
