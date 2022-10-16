import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  final List<PointLatLng> polylinePoints;

  const Directions({
    required this.polylinePoints
  });

  factory Directions.fromMap(List<Map<String, dynamic>> listMap) {
    // if((map['routes'] as List).isEmpty) return null;
    // TODO tratar exeções
    List<PointLatLng> polylinePoints = [];
    listMap.forEach((map) {
      final data = Map<String, dynamic>.from((map['routes'][0]));
      PolylinePoints()
          .decodePolyline(data['overview_polyline']['points'])
          .forEach((polyline) => polylinePoints.add(polyline));
    });

    return Directions(
      polylinePoints: polylinePoints
    );
  }
}
