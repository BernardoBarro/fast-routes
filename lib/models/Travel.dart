class Travel {
  String key = "";
  final String nome;
  final String weekDays;
  final String driverUid;
  final bool viagemIniciada;

  Travel(
      {required this.nome,
      required this.weekDays,
      required this.driverUid,
      required this.viagemIniciada});

  factory Travel.fromRTDB(Map<String, dynamic> data) {
    return Travel(
        nome: data['nome'],
        weekDays: data['weekDays'],
        driverUid: data['driverUid'],
        viagemIniciada: data['viagemIniciada']);
  }

  void setKeys(String key) {
    this.key = key;
  }
}
