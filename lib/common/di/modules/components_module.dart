import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/source/local/prefs/app_preferences.dart';
import '../../../data/source/local/prefs/app_preferences_impl.dart';
import '../../../data/source/upload_photo.dart';
import '../../../utils/environment_info.dart';
import '../../../utils/facebook_wrapper.dart';
import '../../../utils/firebase_wrapper.dart';
import '../../../utils/location_wrapper.dart';
import '../../../utils/uni_link_wrapper.dart';
import '../../../utils/weather_service.dart';
import '../injection/injector.dart';

class ComponentsModule extends DIModule {
  @override
  Future<void> provides() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);

    sl.registerSingleton<EnvironmentInfo>(EnvironmentInfo.pro());

    sl.registerLazySingleton<FacebookWrapper>(() => FacebookWrapper());

    final appDocDirectory = await getApplicationDocumentsDirectory();
    final pathStored = '${appDocDirectory.path}';
    await Directory(pathStored).create(recursive: true);

    ///Database
    Hive.init(pathStored);
    final box = await Hive.openBox('data');

    final AppPreferences appPreferences =
        AppPreferencesImpl(sharedPreferences: sharedPreferences, box: box);
    sl.registerLazySingleton(() => appPreferences);

    final firebaseWrapper = FirebaseWrapper();
    try {
      await firebaseWrapper.init();
      sl.registerLazySingleton<FirebaseWrapper>(() => firebaseWrapper);
    } catch (e) {
      print("FirebaseWrapper :" + e.toString());
    }

    sl.registerLazySingleton<WeatherService>(() => WeatherService());

    final uploadPhoto = UploadPhotos();
    uploadPhoto.init();
    sl.registerLazySingleton<UploadPhotos>(() => uploadPhoto);

    final locationWrapper = LocationWrapper();
    locationWrapper.init();
    sl.registerLazySingleton<LocationWrapper>(() => locationWrapper);
  }
}
