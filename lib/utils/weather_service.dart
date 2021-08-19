/*
  Refer Service: http://dataservice.accuweather.com/
 */
class WeatherService {
  final apiKey = 'i8zwMkoqeL9FAEktNwqNM63HiIWTGo9T';

  /// http://dataservice.accuweather.com/locations/v1/cities/geoposition/search
  String getLocationKey(double lat, double lon) =>
      'https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?q=$lat,$lon&language=en-us&apikey=$apiKey';
  //Weather API Service
  String getWeatherEndPoint(String key) =>
      'http://dataservice.accuweather.com/forecasts/v1/hourly/1hour/$key?metric=true&language=en-us&apikey=$apiKey';

  String getImageLink(String iconCode) =>
      'https://developer.accuweather.com/sites/default/files/${iconCode.length > 1 ? iconCode : ('0' + iconCode)}-s.png';
}
