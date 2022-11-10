class Passageiro {
  final String nome;
  final double origemLatitude;
  final double origemLongitude;
  final double destinoLatitude;
  final double destinoLongitude;
  final bool participa;

  Passageiro(
      {required this.nome,
      required this.origemLatitude,
      required this.origemLongitude,
      required this.destinoLatitude,
      required this.destinoLongitude,
      required this.participa});

  factory Passageiro.fromRTDB(Map<String, dynamic> data) {
    return Passageiro(
      nome: data['nome'],
      origemLatitude: double.parse(data['origemLatitude']),
      origemLongitude: double.parse(data['origemLongitude']),
      destinoLatitude: double.parse(data['destinoLatitude']),
      destinoLongitude: double.parse(data['destinoLongitude']),
      participa: data['participa'],
    );
  }
}
