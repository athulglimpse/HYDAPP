import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:marvista/data/model/app_config.dart';
import 'package:marvista/data/repository/config_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/activity_model.dart';
import '../../../data/model/area_item.dart';
import '../../../data/model/asset_detail.dart';
import '../../../data/model/community_model.dart';
import '../../../data/model/events.dart';
import '../../../data/model/events_detail.dart';
import '../../../data/model/places_model.dart';
import '../../../data/model/suggestion.dart';
import '../../../data/model/weather_info.dart';
import '../../../data/repository/asset_repository.dart';
import '../../../data/repository/event_repository.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/location_repository.dart';
import '../../../data/repository/post_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/api_end_point.dart';
import '../../../utils/date_util.dart';
import '../../assets/asset_see_all/asset_see_all_grid_page.dart';
import '../interactor/home_interactor.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final EventRepository eventRepository;
  final AssetRepository assetRepository;
  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final PostRepository postRepository;
  final ConfigRepository configRepository;

  final HomeInteract homeInteract;

  HomeBloc({
    this.homeRepository,
    this.assetRepository,
    this.eventRepository,
    this.homeInteract,
    this.locationRepository,
    this.userRepository,
    this.postRepository,
    this.configRepository,
  }) : super(HomeState.initial(
            homeRepository, userRepository, eventRepository, assetRepository, configRepository));

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    switch (event.runtimeType) {
      case OnApplyFilter:
        yield handleFilter(event);
        break;
      case FetchAllData:
        final listResult = await Future.wait([
          homeRepository.fetchListExperiences(),
          homeRepository.fetchListWeekendActivities(
              experienceId: state.currentArea?.id?.toString() ?? '',
              filterData: state.facilitesId),
          homeRepository.fetchListCommunity(
              pageIndex: 0,
              filterAdv: state.filterOptSelected,
              experienceId: state.currentArea?.id?.toString() ?? '',
              filterData: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              viewAssetType: ViewAssetType.TRENDING_THIS_WEEK,
              filterAdv: state.filterOptSelected,
              filter: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              viewAssetType: ViewAssetType.TOP_RATE,
              filterAdv: state.filterOptSelected,
              filter: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              viewAssetType: ViewAssetType.RESTAURANTS,
              filterAdv: state.filterOptSelected,
              filter: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              viewAssetType: ViewAssetType.FACILITIES,
              filterAdv: state.filterOptSelected,
              filter: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              filterAdv: state.filterOptSelected,
              viewAssetType: ViewAssetType.ACTIVITIES,
              filter: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              viewAssetType: ViewAssetType.FOOD_TRUCKS,
              filterAdv: state.filterOptSelected,
              filter: state.facilitesId),
          assetRepository.fetchAmenities(
              experiId: state.currentArea?.id?.toString() ?? '',
              viewAssetType: ViewAssetType.MIGHT_LIKE,
              filterAdv: state.filterOptSelected,
              filter: state.facilitesId),
          eventRepository.fetchEvent(
              filterAdv: state.filterOptSelected,
              stateDate:
                  DateUtil.dateFormatDDMMYYYY(DateTime.now(), locale: 'en'),
              endDate: DateUtil.dateFormatDDMMYYYY(
                  DateTime(DateTime.now().year + 1, 12, 31),
                  locale: 'en'),
              experId: state.currentArea?.id?.toString() ?? '',
              filter: state.facilitesId),
        ]);

        yield* homeInteract.handleAreaItemsResult(listResult[0], state);

        yield* homeInteract.handleSuggestionResult(listResult[1], state);

        yield* homeInteract.handleCommunityResult(listResult[2], state);

        yield* homeInteract.handleTrendingByWeekResult(listResult[3], state);

        yield* homeInteract.handleTopRateResult(listResult[4], state);

        yield* homeInteract.handleRestaurantsResult(listResult[5], state);

        yield* homeInteract.handleFacilitiesResult(listResult[6], state);

        yield* homeInteract.handleSportsResult(listResult[7], state);

        yield* homeInteract.handleFoodTrucksResult(listResult[8], state);

        yield* homeInteract.handleMightLikeResult(listResult[9], state);

        yield* homeInteract.handleEventsResult(listResult[10], state);
        break;
      case FetchWeatherInfo:
        final weatherResult = await homeRepository.fetchWeather(
            lat: (event as FetchWeatherInfo).lat,
            lon: (event as FetchWeatherInfo).lon);
        yield* homeInteract.handleWeatherResult(weatherResult, state);
        break;
      case SelectFacility:
        if (state.currentArea?.filter?.isNotEmpty ?? false) {
          final facilitiesId = state.currentArea.filter[0].filterItem
              .where((e) => e.selected)
              .map((e) => e.id)
              .toList()
              .join(',');
          yield state.addFacility(facilitesId: facilitiesId);
        }
        break;
      case SelectExperience:
        yield state.copyWith(
            currentArea: (event as SelectExperience).areaItem,
            facilitesId: '',
            filterOptSelected: <int, Map>{});
        break;
      case FetchListCommunity:
        yield* homeInteract.handleCommunityResult(
            await homeRepository.fetchListCommunity(
                pageIndex: 0,
                experienceId: state.currentArea?.id?.toString() ?? '',
                filterData: state.facilitesId),
            state);
        break;

      case AddPostFavorite:
        final ev = event as AddPostFavorite;
        if (ev.communityPost.isFavorite != null) {
          ev.communityPost.isFavorite = !ev.communityPost.isFavorite;
        }
        yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());
        await homeRepository.addFavorite(ev.communityPost.id.toString(),
            ev.communityPost.isFavorite ?? false, FavoriteType.COMMUNITY_POST);
        // add(FetchListCommunity());
        break;
      case EstimateDistance:
        switch ((event as EstimateDistance).viewAssetType) {
          case ViewAssetType.TRENDING_THIS_WEEK:
            yield* homeInteract.estTimeByDistance(event, state.listTrending,
                ViewAssetType.TRENDING_THIS_WEEK, state, locationRepository);
            break;
          default:
            yield state;
        }
        break;
      case FetchListEvents:
        yield* homeInteract.handleEventsResult(
            await eventRepository.fetchEvent(
                stateDate:
                    DateUtil.dateFormatDDMMYYYY(DateTime.now(), locale: 'en'),
                endDate: DateUtil.dateFormatDDMMYYYY(
                    DateTime(DateTime.now().year + 1, 12, 31),
                    locale: 'en'),
                experId: state.currentArea?.id?.toString() ?? ''),
            state);
        break;
      case RemoveEvent:
        await postRepository.removePostFromFeed(
            (event as RemoveEvent).id, 'add', ENTITY_TYPE_NODE);
        add(FetchListEvents());
        break;
      case TurnOffEvent:
        await postRepository.turnOffPostFromOwner(
            (event as TurnOffEvent).id, 'add', ENTITY_TYPE_NODE);
        add(FetchListEvents());
        break;
      case EnterHomePage:
        yield state.copyWith(homeRoute: HomeRoute.enterHomePage);
        break;
      case EnterDetail:
        yield state.copyWith(
            assetDetailId: (event as EnterDetail).areaItem.idContent,
            currentArea: state.listAreas[0],
            facilitesId: '',
            homeRoute: (event as EnterDetail).areaItem.bundle == 'event_details'
                ? HomeRoute.enterEventDetailPage
                : HomeRoute.enterAssetDetailPage);
        break;
      default:
    }
  }

  HomeState handleFilter(OnApplyFilter event) {
    return state.copyWith(filterOptSelected: event.filterOptSelected);
  }
}
