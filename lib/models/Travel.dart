class Travel {
  String key = "";
  final String nome;
  final String weekDays;
  final String driverUid;

  Travel({required this.nome, required this.weekDays, required this.driverUid});

  factory Travel.fromRTDB(Map<String, dynamic> data) {
    return Travel(
        nome: data['nome'],
        weekDays: data['weekDays'],
        driverUid: data['driverUid']);
  }

  void setKeys(String key) {
    this.key = key;
  }
}
