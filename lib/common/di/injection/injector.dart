import 'package:get_it/get_it.dart';

import '../modules/api_module.dart';
import '../modules/applink_module.dart';
import '../modules/bloc_module.dart';
import '../modules/components_module.dart';
import '../modules/repository_module.dart';

final sl = GetIt.instance;

abstract class DIModule {
  void provides();
}

class Injection {
  static Future<void> inject() async {
    await ComponentsModule().provides();
    await ApiModule().provides();
    await RepositoryModule().provides();
    await BlocModule().provides();
    await AppLinkModule().provides();
  }
}
