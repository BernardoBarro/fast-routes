class Passageiro {
  final String nome;
  final String latitude;
  final String longitude;

  Passageiro(
      {required this.nome, required this.latitude, required this.longitude});

  factory Passageiro.fromRTDB(Map<String, dynamic> data) {
    print(data);
    return Passageiro(
        nome: data['nome'],
        latitude: data['latitude'],
        longitude: data['longitude']);
  }
}
