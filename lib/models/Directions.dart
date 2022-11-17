import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  final List<String> distance;

  const Directions({
    required this.distance
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    List<String> distance = [];
    // if((map['routes'] as List).isEmpty) return null;
    // TODO tratar exeções
    final data = Map<String, dynamic>.from((map['rows'][0]));
    for(int i=0;i<=data.length;i++){
      distance.add(data['elements'][i]['distance']['text']);
    }

    // List<PointLatLng> polylinePoints = [];
    // listMap.forEach((map) {
    //   final data = Map<String, dynamic>.from((map['routes'][0]));
    //   PolylinePoints()
    //       .decodePolyline(data['overview_polyline']['points'])
    //       .forEach((polyline) => polylinePoints.add(polyline));
    // });

    return Directions(
        distance: distance
    );
  }
}
