import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  // final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;

  // final String totalDistance;
  // final String totalduration;

  const Directions({
    // required this.bounds,
    required this.polylinePoints,
    // required this.totalDistance,
    // required this.totalduration,
  });

  factory Directions.fromMap(List<Map<String, dynamic>> listMap) {
    List<PointLatLng> polylinePoints = [];
    // if((map['routes'] as List).isEmpty) return null;
    listMap.forEach((map) {
      final data = Map<String, dynamic>.from((map['routes'][0]));
      PolylinePoints()
          .decodePolyline(data['overview_polyline']['points'])
          .forEach((element) => polylinePoints.add(element));
    });

    // final northeast = data['bounds']['northeast'];
    // final southwest = data['bounds']['southwest'];
    // final bounds = LatLngBounds(
    //   northeast: LatLng(northeast['lat'], northeast['lng']),
    //   southwest: LatLng(southwest['lat'], southwest['lng']),
    // );
    //
    // String distance = '';
    // String duration = '';
    // if((data['legs'] as List).isNotEmpty){
    //   final leg = data['legs'][0];
    //   distance = leg['distance']['text'];
    //   duration = leg['duration']['text'];
    // }

    return Directions(
      // bounds: bounds,
      polylinePoints: polylinePoints,
      // totalDistance: distance,
      // totalduration: duration,
    );
  }
}
