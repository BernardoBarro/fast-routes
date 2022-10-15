import 'dart:async';

import 'package:fast_routes/models/Passageiro.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Travel.dart';

class AddressProvider extends ChangeNotifier {
  List<Passageiro> _address = [];
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  static const PASS_PATH = '/viagens/-NER-JZ617H9fgrKwDRR/passageiros';

  late StreamSubscription<DatabaseEvent> _addressStream;

  List<Passageiro> get address => _address;

  AddressProvider() {
    _listenToAddress();
  }

  void _listenToAddress() {
    String uid = usuarioLogado!.uid;
    _addressStream = _db.child(uid+PASS_PATH).onValue.listen((event) {
      print(event.snapshot.value);
      final allAddress =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _address = allAddress.values
          .map((addressAsJSON) =>
          Passageiro.fromRTDB(Map<String, dynamic>.from(addressAsJSON)))
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
