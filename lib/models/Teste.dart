class Teste {
  final String distance;
  final String nome;
  final int distanceValue;

  Teste({required this.distance, required this.nome, required this.distanceValue});

  factory Teste.fromRTDB(String distance, String nome, int distanceValue) {
    return Teste(distance: distance, nome: nome, distanceValue: distanceValue);
  }
}
