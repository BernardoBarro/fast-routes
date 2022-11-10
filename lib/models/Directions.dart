import 'package:fast_routes/models/Passageiro.dart';

import 'Teste.dart';

class Directions {
  final List<Teste> distance;

  const Directions({required this.distance});

  factory Directions.fromMap(
      Map<String, dynamic> map, List<Passageiro> address) {
    List<Teste> distance = [];
    // if((map['routes'] as List).isEmpty) return null;
    // TODO tratar exeções
    final data = Map<String, dynamic>.from((map['rows'][0]));
    print("aqui");
    print(data['elements'].length);
    print(address);
    for (int i = 0; i < data['elements'].length; i++) {
      Teste teste = Teste(
          distance: data['elements'][i]['distance']['text'],
          nome: address[i].nome,
          distanceValue: data['elements'][i]['distance']['value']);
      distance.add(teste);
    }

    List<Teste> response = [];
    // List<PointLatLng> polylinePoints = [];
    // listMap.forEach((map) {
    //   final data = Map<String, dynamic>.from((map['routes'][0]));
    //   PolylinePoints()
    //       .decodePolyline(data['overview_polyline']['points'])
    //       .forEach((polyline) => polylinePoints.add(polyline));
    // });
    return Directions(distance: distance);
  }
}
