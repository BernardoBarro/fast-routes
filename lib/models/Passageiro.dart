class Passageiro {
  String key = "";
  final String nome;
  final double origemLatitude;
  final double origemLongitude;
  final double destinoLatitude;
  final double destinoLongitude;
  final bool participa;
  final bool origem;

  Passageiro({
    required this.nome,
    required this.origemLatitude,
    required this.origemLongitude,
    required this.destinoLatitude,
    required this.destinoLongitude,
    required this.participa,
    required this.origem,
  });

  factory Passageiro.fromRTDB(Map<String, dynamic> data) {
    return Passageiro(
      nome: data['nome'],
      origemLatitude: double.parse(data['origemLatitude']),
      origemLongitude: double.parse(data['origemLongitude']),
      destinoLatitude: double.parse(data['destinoLatitude']),
      destinoLongitude: double.parse(data['destinoLongitude']),
      participa: data['participa'],
      origem: data['origem']
    );
  }

  void setKeys(String key) {
    this.key = key;
  }
}
