import 'package:fast_routes/models/Passageiro.dart';

import 'Teste.dart';

class Directions {
  final List<Teste> distance;

  const Directions({required this.distance});

  factory Directions.fromMap(
      Map<String, dynamic> map, List<Passageiro> address) {
    List<Teste> distance = [];
    final data = Map<String, dynamic>.from((map['rows'][0]));
    for (int i = 0; i < data['elements'].length; i++) {
      Teste teste = Teste(
        distance: data['elements'][i]['distance']['text'],
        nome: address[i].nome,
        destinoLatitude: address[i].destinoLatitude,
        destinoLongitude: address[i].destinoLongitude,
        origemLatitude: address[i].origemLatitude,
        origemLongitude: address[i].origemLongitude,
        distanceValue: data['elements'][i]['distance']['value'],
        origem: address[i].origem,
        passagerUid: address[i].key,
      );
      distance.add(teste);
    }
    distance.sort((a, b) => a.distanceValue.compareTo(b.distanceValue));

    return Directions(distance: distance);
  }
}
