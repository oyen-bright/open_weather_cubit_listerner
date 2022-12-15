// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class GeoCoding extends Equatable {
  final String name;
  final double log;
  final double lat;
  final String country;
  const GeoCoding({
    required this.name,
    required this.log,
    required this.lat,
    required this.country,
  });

  @override
  List<Object?> get props => [name, lat, log, country];

  factory GeoCoding.fromJson(List<dynamic> json) {
    final Map<String, dynamic> geoData = json[0];
    return GeoCoding(
        name: geoData["name"],
        log: geoData["lon"],
        lat: geoData["lat"],
        country: geoData["country"]);
  }

  @override
  bool get stringify => true;
}
