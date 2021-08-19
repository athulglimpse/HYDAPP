
import '../../../utils/uni_link_wrapper.dart';
import '../injection/injector.dart';

class AppLinkModule extends DIModule {
  @override
  Future<void> provides() async {
    final uniLinkWrapper = UniLinkWrapper();
    await uniLinkWrapper.initPlatformState();
    sl.registerLazySingleton<UniLinkWrapper>(() => uniLinkWrapper);
  }
}
