import 'package:data_connection_checker/data_connection_checker.dart';

import '../../../data/repository/activity_repository.dart';
import '../../../data/repository/asset_repository.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/event_repository.dart';
import '../../../data/repository/help_report_repository.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/location_repository.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/repository/personalize_repository.dart';
import '../../../data/repository/post_repository.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../data/repository/search_repository.dart';
import '../../../data/repository/static_content_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/local/activity_local_datasource.dart';
import '../../../data/source/local/asset_local_datasource.dart';
import '../../../data/source/local/config_local_datasource.dart';
import '../../../data/source/local/event_local_datasource.dart';
import '../../../data/source/local/help_report_local_datasource.dart';
import '../../../data/source/local/home_local_datasource.dart';
import '../../../data/source/local/location_local_datasource.dart';
import '../../../data/source/local/notification_local_datasource.dart';
import '../../../data/source/local/personalize_local_datasource.dart';
import '../../../data/source/local/post_local_datasource.dart';
import '../../../data/source/local/profile_local_datasource.dart';
import '../../../data/source/local/search_local_datasource.dart';
import '../../../data/source/local/static_content_local_datasource.dart';
import '../../../data/source/local/user_local_datasource.dart';
import '../../../data/source/remote/activity_remote_data_source.dart';
import '../../../data/source/remote/asset_remote_data_source.dart';
import '../../../data/source/remote/config_remote_data_source.dart';
import '../../../data/source/remote/event_remote_data_source.dart';
import '../../../data/source/remote/help_report_remote_data_source.dart';
import '../../../data/source/remote/home_remote_data_source.dart';
import '../../../data/source/remote/location_remote_data_source.dart';
import '../../../data/source/remote/notification_remote_data_source.dart';
import '../../../data/source/remote/personalize_remote_data_source.dart';
import '../../../data/source/remote/post_remote_data_source.dart';
import '../../../data/source/remote/profile_remote_data_source.dart';
import '../../../data/source/remote/search_remote_data_source.dart';
import '../../../data/source/remote/static_remote_data_source.dart';
import '../../../data/source/remote/user_remote_data_source.dart';
import '../../../ui/assets/asset_see_all/interactor/asset_see_all_interact.dart';
import '../../../ui/assets/asset_see_all/interactor/asset_see_all_interact_impl.dart';
import '../../../ui/home/interactor/home_interactor.dart';
import '../../../ui/home/interactor/home_interactor_impl.dart';
import '../../../ui/notification_history/interactor/notification_interactor.dart';
import '../../../ui/notification_history/interactor/notification_interactor_impl.dart';
import '../../../utils/network_info.dart';
import '../injection/injector.dart';

class RepositoryModule extends DIModule {
  @override
  Future<void> provides() async {
    /// Repositories
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl()),
    );
    sl.registerLazySingleton(() => DataConnectionChecker());

    /// Repositories - Remote
    sl.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(),
    );
    sl.registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(weatherService: sl()),
    );
    sl.registerFactory<PersonalizeRemoteDataSource>(
      () => PersonalizeRemoteDataSourceImpl(),
    );
    sl.registerFactory<StaticContentRemoteDataSource>(
      () => StaticContentRemoteDataSourceImpl(),
    );
    sl.registerFactory<ConfigRemoteDataSource>(
      () => ConfigRemoteDataSourceImpl(),
    );
    sl.registerFactory<HelpAndReportRemoteDataSource>(
      () => HelpAndReportRemoteDataSourceImpl(),
    );
    sl.registerFactory<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(),
    );
    sl.registerFactory<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(),
    );
    sl.registerFactory<ActivityRemoteDataSource>(
      () => ActivityRemoteDataSourceImpl(),
    );
    sl.registerFactory<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(),
    );
    sl.registerFactory<EventRemoteDataSource>(
      () => EventRemoteDataSourceImpl(),
    );
    sl.registerFactory<AssetRemoteDataSource>(
      () => AssetRemoteDataSourceImpl(),
    );
    sl.registerFactory<LocationRemoteDataSource>(
      () => LocationRemoteDataSourceImpl(),
    );

    sl.registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(),
    );

    /// Repositories - LocalData
    ///
    sl.registerFactory<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<PersonalizeLocalDataSource>(
      () => PersonalizeLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<StaticContentLocalDataSource>(
      () => StaticContentLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<ConfigLocalDataSource>(
      () => ConfigLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<HelpReportLocalDataSource>(
      () => HelpReportLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<ActivityLocalDataSource>(
      () => ActivityLocalDataSourceImpl(appPreferencesImpl: sl()),
    );
    sl.registerFactory<EventLocalDataSource>(
      () => EventLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<AssetLocalDataSource>(
      () => AssetLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<LocationLocalDataSource>(
      () => LocationLocalDataSourceImpl(appPreferences: sl()),
    );
    sl.registerFactory<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(sharedPreferences: sl()),
    );

    /// Repositories - Impl
    sl.registerFactory<UserRepository>(
        () => UserRepositoryImpl(remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<HomeRepository>(() => HomeRepositoryImpl(
          remoteDataSource: sl(),
          localDataSrc: sl(),
          locationWrapper: sl(),
        ));
    sl.registerFactory<PersonalizeRepository>(() =>
        PersonalizeRepositoryImpl(remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<ConfigRepository>(
        () => ConfigRepositoryImpl(remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<HelpAndReportRepository>(() =>
        HelpAndReportRepositoryImpl(
            remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<StaticContentRepository>(() =>
        StaticContentRepositoryImpl(
            remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<NotificationRepository>(() =>
        NotificationRepositoryImpl(remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<PostRepository>(() => PostRepositoryImpl(
        remoteDataSource: sl(), localDataSrc: sl(), locationWrapper: sl()));
    sl.registerFactory<ActivityRepository>(() =>
        ActivityRepositoryImpl(localDataSrc: sl(), remoteDataSource: sl()));
    sl.registerFactory<EventRepository>(() => EventRepositoryImpl(
          remoteDataSource: sl(),
          locationWrapper: sl(),
          localDataSrc: sl(),
        ));
    sl.registerFactory<SearchRepository>(() => SearchRepositoryImpl(
          remoteDataSource: sl(),
          localDataSource: sl(),
        ));
    sl.registerFactory<AssetRepository>(() => AssetRepositoryImpl(
        remoteDataSource: sl(), localDataSrc: sl(), locationWrapper: sl()));
    sl.registerFactory<LocationRepository>(() =>
        LocationRepositoryImpl(remoteDataSource: sl(), localDataSrc: sl()));
    sl.registerFactory<ProfileRepository>(() =>
        ProfileRepositoryImpl(remoteDataSource: sl(), localDataSrc: sl()));

    /// interactor
    sl.registerFactory<HomeInteract>(() => HomeInteractImpl());
    sl.registerFactory<NotificationHistoryInteract>(
        () => NotificationHistoryInteractImpl());
    sl.registerFactory<AssetSeeAllInteract>(() => AssetSeeAllInteractImpl());
  }
}
