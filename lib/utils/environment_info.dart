import 'app_const.dart';

const String HOST_PROD = 'https://www.hudayriyatisland.ae';
const String HOST_DEV = 'https://hudayriyat-staging.asiadigitalhub.net';
const String HOST_STAG = 'https://uat.hudayriyatisland.ae';

const String VERSION = 'v2';

class EnvironmentInfo {
  final String host;
  final String version;
  final String apiKey;
  final String ggKey;
  String _accessToken = '';

  set accessToken(String accessToken) => _accessToken = accessToken;
  String get accessToken => _accessToken;

  EnvironmentInfo._({
    this.host,
    this.version,
    this.apiKey,
    this.ggKey,
  });

  // ignore: use_setters_to_change_properties
  void updateAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  factory EnvironmentInfo.dev() {
    return EnvironmentInfo._(
      host: HOST_DEV,
      version: VERSION,
      apiKey: IAP_K,
      ggKey: GG_K,
    );
  }
  factory EnvironmentInfo.stag() {
    return EnvironmentInfo._(
      host: HOST_STAG,
      version: VERSION,
      apiKey: IAP_K,
      ggKey: GG_K,
    );
  }
  factory EnvironmentInfo.pro() {
    return EnvironmentInfo._(
      host: HOST_PROD,
      version: VERSION,
      apiKey: IAP_K,
      ggKey: GG_K,
    );
  }
}
