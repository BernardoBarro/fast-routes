import 'dart:async';

import 'package:fast_routes/models/Address.dart';
import 'package:fast_routes/models/Passageiro.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PassengersAddressProvider extends ChangeNotifier {
  List<Address> _address = [];
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  // TODO alterar o id da viagem conforme a viagem do motorista
  static const PASS_PATH = '/endereco';

  late StreamSubscription<DatabaseEvent> _addressStream;

  List<Address> get address => _address;

  PassengersAddressProvider() {
    _listenToAddress();
  }

  void _listenToAddress() {
    String uid = usuarioLogado!.uid;
    _addressStream = _db.child(uid + PASS_PATH).onValue.listen((event) {
      final allAddress =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
          print('ALL ADDRESSES: - $allAddress');
      _address = allAddress.values
          .map((addressAsJSON) => Address.fromRTDB(Map<String, dynamic>.from(addressAsJSON)))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _addressStream.cancel();
    super.dispose();
  }
}
