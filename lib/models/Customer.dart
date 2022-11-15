class Customer {
  String uid = "";
  final String nome;
  final String email;
  final bool participa;

  Customer({required this.nome, required this.email, required this.participa});

  factory Customer.fromRTDB(Map<String, dynamic> data) {
    return Customer(
        nome: data['nome'], email: data['email'], participa: data['participa']);
  }

  void setKeys(String key) {
    this.uid = key;
  }
}
