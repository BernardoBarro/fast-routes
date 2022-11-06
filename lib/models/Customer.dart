class Customer {
  String uid = "";
  final String nome;
  final String email;

  Customer({required this.nome, required this.email});

  factory Customer.fromRTDB(Map<String, dynamic> data) {
    return Customer(nome: data['nome'], email: data['email']);
  }

  void setKeys(String key) {
    this.uid = key;
  }
}
