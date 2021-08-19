import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/community_model.dart';
import '../../../../data/repository/home_repository.dart';

part 'community_see_all_event.dart';
part 'community_see_all_state.dart';

class CommunitySeeAllBloc
    extends Bloc<CommunitySeeAllEvent, CommunitySeeAllState> {
  final HomeRepository homeRepository;
  CommunitySeeAllBloc({this.homeRepository})
      : super(CommunitySeeAllState.initial(homeRepository));

  @override
  Stream<CommunitySeeAllState> mapEventToState(
    CommunitySeeAllEvent event,
  ) async* {
    if (event is AddPostToFavorite) {
      if (event.communityPost.isFavorite != null) {
        event.communityPost.isFavorite = !event.communityPost.isFavorite;
      }
      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      await homeRepository.addFavorite(event.communityPost.id.toString(),
          event.communityPost.isFavorite ?? false, FavoriteType.COMMUNITY_POST);
    }
  }
}
