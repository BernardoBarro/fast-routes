class Customer {
  final String nome;
  final String email;
  final String phone;
  final String cpf;
  final String birthDate;

  Customer(
      {required this.nome,
      required this.email,
      required this.phone,
      required this.cpf,
      required this.birthDate});

  factory Customer.fromRTDB(Map<String, dynamic> data) {
    return Customer(
        nome: data['nome'],
        email: data['email'],
        phone: data['telefone'],
        cpf: data['cpf'],
        birthDate: data['data_de_nascimento']);
  }
}
