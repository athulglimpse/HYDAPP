import 'dart:convert';

import 'package:marvista/ui/filter/util/filter_util.dart';
import 'package:marvista/utils/log_utils.dart';
import 'package:marvista/utils/date_util.dart';

import '../../model/area_item.dart';

import '../../model/event_category.dart';
import '../../model/events.dart';
import '../../model/events_detail.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class EventRemoteDataSource {
  ///GET API
  Future<EventDetailInfo> fetchEventDetail({String id});

  Future<List<EventInfo>> fetchEvent(
      {String stateDate,
      String endDate,
      String cate,
      Map<int, Map> filterAdv,
      dynamic filter,
      String experId});

  Future<List<EventCategory>> fetchEventCategories();

  Future<List<EventInfo>> fetchMoreEventLikeThis({String id, String cate});
}

class EventRemoteDataSourceImpl extends RemoteBaseImpl
    implements EventRemoteDataSource {
  EventRemoteDataSourceImpl();

  @override
  Future<EventDetailInfo> fetchEventDetail({
    String id,
  }) async {
    setPrivateToken();
    final response = await dio.get(endPointGetEventsDetail,
        queryParameters: {'id': id}).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<EventDetailInfo>(response, (responseData) {
      final event= EventDetailInfo.fromJson(responseData.data);
      if(event.eventTime != null){
        final position = DateUtil.positionSameMomentAs(event.eventTime);
        event.eventTime = event.eventTime.sublist(position, event.eventTime.length);
      }
      return event;
    });
  }

  @override
  Future<List<EventInfo>> fetchEvent({
    String stateDate,
    String endDate,
    String cate,
    Map<int, Map> filterAdv,
    dynamic filter,
    String experId,
  }) async {
    setPrivateToken();

    final filterAdvData = <Map>[];
    try {
      if (filterAdv?.isNotEmpty ?? false) {
        filterAdv.entries.forEach((e) {
          if (e.value['type'] == 'selection' && e.value['value'] != null) {
            final filterItem = e.value['value'];
            filterAdvData.add({
              'fid': e.value['fid'],
              'type': e.value['type'],
              'data': [filterItem.id],
            });
          } else if (e.value['type'] == 'multi_selection') {
            final Map<int, FilterItem> filterItem = e.value['value'];
            final listId = <int>[];
            filterItem.forEach((key, value) {
              listId.add(value.id);
            });
            if (listId.isNotEmpty) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'data': listId,
              });
            }
          } else if (e.value['type'] == 'icon_single_selection') {
            final filterItem = e.value['value'];
            if (filterItem != null) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'data': [filterItem.id],
              });
            }
          } else if (e.value['type'] == 'icon_multi_selection') {
            final Map<int, FilterItem> filterItem = e.value['value'];
            final listId = <int>[];
            filterItem.forEach((key, value) {
              listId.add(value.id);
            });
            if (listId.isNotEmpty) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'data': listId,
              });
            }
          } else if (e.value['type'] == 'date') {
            final String startDate = e.value[FILTER_KEY_START_DATE];
            final String endDate = e.value[FILTER_KEY_END_DATE];
            if ((startDate != null && startDate.isNotEmpty) ||
                (endDate != null && endDate.isNotEmpty)) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'by_date': {'startdate': startDate, 'enddate': endDate},
              });
            }
          }
        });
      }
    } catch (e) {
      LogUtils.d(e);
    }

    final response = await dio
        .get(endPointGetEvents,
            queryParameters: Map.from({
              PARAM_CATEGORY: cate,
              PARAM_FILTER_FACILITY: filter,
              PARAM_START_DATE: stateDate,
              'filter':
                  filterAdvData.isNotEmpty ? json.encode(filterAdvData) : '',
              PARAM_END_DATE: endDate
            }))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<EventInfo>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      final listEvent = strMap.map((v) => EventInfo.fromJson(v)).toList();
      for (var i = 0; i < listEvent.length; i++) {
        final position = DateUtil.positionSameMomentAs(listEvent[i].eventTime);
        listEvent[i].eventTime = listEvent[i].eventTime.sublist(position, listEvent[i].eventTime.length);
      }
      return listEvent;
    });
  }

  @override
  Future<List<EventCategory>> fetchEventCategories() async {
    setPrivateToken();
    final response =
        await dio.get(endPointGetEventsCategories).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<EventCategory>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => EventCategory.fromJson(v))?.toList() ?? [];
    });
  }

  @override
  Future<List<EventInfo>> fetchMoreEventLikeThis(
      {String id, String cate}) async {
    setPrivateToken();
    final queryParameters = Map<String, String>.from({
      PARAM_CATEGORY: cate,
      PARAM_ID: id,
    });
    final response = await dio
        .get(endPointGetEventsAlsoLike, queryParameters: queryParameters)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<EventInfo>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => EventInfo.fromJson(v))?.toList() ?? [];
    });
  }
}
