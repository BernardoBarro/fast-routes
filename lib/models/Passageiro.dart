class Passageiro {
  final String nome;
  final double latitude;
  final double longitude;

  Passageiro(
      {required this.nome, required this.latitude, required this.longitude});

  factory Passageiro.fromRTDB(Map<String, dynamic> data) {
    print(data);
    return Passageiro(
        nome: data['nome'],
        latitude: double.parse(data['latitude']),
        longitude: double.parse(data['longitude']));
  }
}
