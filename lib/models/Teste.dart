class Teste {
  final String distance;
  final String nome;
  final int distanceValue;
  final double origemLatitude;
  final double origemLongitude;
  final double destinoLatitude;
  final double destinoLongitude;
  final bool origem;
  final String passagerUid;

  Teste({
    required this.distance,
    required this.nome,
    required this.origemLatitude,
    required this.origemLongitude,
    required this.destinoLatitude,
    required this.destinoLongitude,
    required this.distanceValue,
    required this.origem,
    required this.passagerUid,
  });

  factory Teste.fromRTDB(
    String distance,
    String nome,
    double origemLatitude,
    double origemLongitude,
    double destinoLatitude,
    double destinoLongitude,
    int distanceValue,
    bool origem,
    String passagerUid,
  ) {
    return Teste(
      distance: distance,
      nome: nome,
      origemLatitude: origemLatitude,
      origemLongitude: origemLongitude,
      destinoLatitude: destinoLatitude,
      destinoLongitude: destinoLongitude,
      distanceValue: distanceValue,
      origem: origem,
      passagerUid: passagerUid,
    );
  }
}
