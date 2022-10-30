import 'dart:async';

import 'package:fast_routes/models/Customer.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Travel.dart';

class TravelPassagerProvider extends ChangeNotifier {
  List<Customer> _passageiros = [];
  late Travel singleTravel;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  static const TRAVEL_PATH = '/viagens';

  late StreamSubscription<DatabaseEvent> _travelStream;

  List<Customer> get passageiros => _passageiros;
  Travel get travel => singleTravel;

  TravelPassagerProvider(String key) {
    _listenToTravelsPassagers(key);
    _getSingleTravel(key);
  }

  void _listenToTravelsPassagers(String key) {
    String uid = usuarioLogado!.uid;
    _travelStream = _db.child(uid + TRAVEL_PATH + "/$key/passageiros").onValue.listen((event) {
      final allPassageiros =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _passageiros = allPassageiros.values
          .map((travelAsJSON) =>
              Customer.fromRTDB(Map<String, dynamic>.from(travelAsJSON), ""))
          .toList();
      notifyListeners();
    });
  }

  void _getSingleTravel(String key) {
    String uid = usuarioLogado!.uid;
    _db.child(uid + TRAVEL_PATH + "/$key").get().then((snapshot) {
      final data = new Map<String, dynamic>.from((snapshot.value as dynamic));
      singleTravel = Travel.fromRTDB(data);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _travelStream.cancel();
    super.dispose();
  }
}
