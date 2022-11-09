class Address {
  String uid = "";
  final String endereco;

  Address({required this.endereco});

  factory Address.fromRTDB(Map<String, dynamic> data) {
    return Address(endereco: data['endereco']);
  }

  void setKeys(String key) {
    this.uid = key;
  }
}
