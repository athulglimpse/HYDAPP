part of 'weekend_activity_see_all_bloc.dart';

@immutable
abstract class WeekendActivitySeeAllEvent {}

class FetchActivities extends WeekendActivitySeeAllEvent {
  final int experience;
  final Map<int, Map> filterAdv;

  FetchActivities({this.filterAdv, this.experience});
}
