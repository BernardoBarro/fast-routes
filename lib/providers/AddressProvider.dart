import 'dart:async';

import 'package:fast_routes/models/Passageiro.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressProvider extends ChangeNotifier {
  List<Passageiro> _address = [];
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  // TODO alterar o id da viagem conforme a viagem do motorista
  static const PASS_PATH = '/viagens/-NER-JZ617H9fgrKwDRR/passageiros';

  late StreamSubscription<DatabaseEvent> _addressStream;

  List<Passageiro> get address => _address;

  AddressProvider({String? chave}) {
    if (chave != null) {
      _listenToAddress(chave);
    }
  }

  void _listenToAddress(String? chave) {
    String uid = usuarioLogado!.uid;
    _addressStream = _db
        .child(uid)
        .child("viagens")
        .child(chave!)
        .child("passageiros")
        .onValue
        .listen((event) {
      final allAddress =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _address = allAddress.values
          .map((addressAsJSON) =>
              Passageiro.fromRTDB(Map<String, dynamic>.from(addressAsJSON)))
          .toList();
      print(_address.first.participa);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _addressStream.cancel();
    super.dispose();
  }
}
