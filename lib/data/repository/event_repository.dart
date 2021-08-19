import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../utils/app_const.dart';
import '../../utils/location_wrapper.dart';
import '../model/event_category.dart';
import '../model/events.dart';
import '../model/events_detail.dart';
import '../source/failure.dart';
import '../source/local/event_local_datasource.dart';
import '../source/remote/event_remote_data_source.dart';
import 'repository.dart';

abstract class EventRepository {
  ///GET API
  Future<Either<Failure, EventDetailInfo>> fetchEventDetail({String id});

  Future<Either<Failure, List<EventInfo>>> fetchEvent({
    String stateDate,
    String endDate,
    String cate,
    Map<int, Map> filterAdv,
    dynamic filter,
    String experId,
  });

  Future<Either<Failure, List<EventCategory>>> fetchEventCategories();

  Future<Either<Failure, List<EventInfo>>> fetchMoreEventLikeThis(
      {String id, String cate});

  ///Local Data
  List<EventInfo> getEvents();

  EventDetailInfo getEventDetail(String id);

  List<EventCategory> getEventCategories();

  void saveEvents(List<EventInfo> events);

  void saveEventDetail(EventDetailInfo events);

  void saveCategories(List<EventCategory> categories);
}

class EventRepositoryImpl extends Repository implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final LocationWrapper locationWrapper;
  final EventLocalDataSource localDataSrc;

  EventRepositoryImpl({
    @required this.remoteDataSource,
    @required this.locationWrapper,
    @required this.localDataSrc,
  });

  @override
  Future<Either<Failure, EventDetailInfo>> fetchEventDetail({String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.fetchEventDetail(id: id);
        saveEventDetail(events);
        return Right(events);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<EventInfo>>> fetchMoreEventLikeThis(
      {String id, String cate}) async {
    if (await networkInfo.isConnected) {
      try {
        final categories =
            await remoteDataSource.fetchMoreEventLikeThis(id: id, cate: cate);
        //saveCategories(categories);
        return Right(categories);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<EventInfo>>> fetchEvent(
      {String stateDate,
      String endDate,
      String cate,
      Map<int, Map> filterAdv,
      dynamic filter,
      String experId}) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.fetchEvent(
          stateDate: stateDate,
          endDate: endDate,
          cate: cate,
          filterAdv: filterAdv,
          filter: filter,
          experId: experId,
        );

        events.forEach((e) async {
          e.distance = await _distance(e);
        });

        saveEvents(events);
        return Right(events);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<EventCategory>>> fetchEventCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.fetchEventCategories();
        saveCategories(categories);
        return Right(categories);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  void saveEvents(List<EventInfo> events) {
    return localDataSrc.saveEvents(events);
  }

  @override
  List<EventInfo> getEvents() {
    final events = localDataSrc.getEvents();
    return events;
  }

  @override
  void saveCategories(List<EventCategory> categories) {
    return localDataSrc.saveCategories(categories);
  }

  @override
  List<EventCategory> getEventCategories() {
    final categories = localDataSrc.getEventCategories();
    return categories;
  }

  @override
  void saveEventDetail(EventDetailInfo events) {
    return localDataSrc.saveEventDetail(events);
  }

  @override
  EventDetailInfo getEventDetail(String id) {
    return localDataSrc.getEventDetail(id);
  }

  Future<double> _distance(EventInfo event) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            event?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            event?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return distance;
  }
}
