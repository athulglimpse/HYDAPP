import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/event_category.dart';
import '../../model/events.dart';
import '../../model/events_detail.dart';
import 'prefs/app_preferences.dart';

abstract class EventLocalDataSource {
  ///Local Data
  EventDetailInfo getEventDetail(String id);

  List<EventInfo> getEvents();

  List<EventCategory> getEventCategories();

  void saveEvents(List<EventInfo> events);

  void saveEventDetail(EventDetailInfo eventDetail);

  void saveCategories(List<EventCategory> categories);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final AppPreferences appPreferences;

  EventLocalDataSourceImpl({@required this.appPreferences});

  @override
  EventDetailInfo getEventDetail(String id) {
    try {
      final jsonString = appPreferences.getEventDetail(id);
      if (jsonString != null) {
        return EventDetailInfo.fromJson(json.decode(jsonString));
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  List<EventInfo> getEvents() {
    try {
      final jsonString = appPreferences.getEvents();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final events = strMap.map((v) => EventInfo.fromJson(v)).toList();
        return events;
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  List<EventCategory> getEventCategories() {
    try {
      final jsonString = appPreferences.getEventCategories();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final categories =
            strMap.map((v) => EventCategory.fromJson(v)).toList();
        return categories;
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void saveEvents(List<EventInfo> events) {
    final str = events.map((v) => v.toJson()).toList();
    return appPreferences.saveEvents(json.encode(str));
  }

  @override
  void saveCategories(List<EventCategory> categories) {
    final str = categories.map((v) => v.toJson()).toList();
    return appPreferences.saveEventCategories(json.encode(str));
  }

  @override
  void saveEventDetail(EventDetailInfo eventDetail) {
    return appPreferences.saveEventDetail(
        json.encode(eventDetail.toJson()), eventDetail.id.toString());
  }
}
