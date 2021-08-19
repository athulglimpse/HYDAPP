import '../../../data/model/amenity_model.dart';

class Place {
  final String name;
  final bool isClosed;
  final String snippet;
  final String title;
  final AmenityModel amenityModel;

  String get shortTitle {
    if ((title?.length ?? 0) > 8) {
      return '${title.substring(0, 8)}...';
    }
    return title;
  }

  String get shortSnippet {
    if ((snippet?.length ?? 0) > 8) {
      return '${snippet.substring(0, 8)}...';
    }
    return snippet;
  }

  Place({
    this.name,
    this.isClosed,
    this.snippet,
    this.amenityModel,
    this.title,
  });
}
