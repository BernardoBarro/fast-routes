import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Travel.dart';

class TravelProvider extends ChangeNotifier {
  List<Travel> _travel = [];
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  static const TRAVEL_PATH = '/viagens';

  late StreamSubscription<DatabaseEvent> _travelStream;

  List<Travel> get travels => _travel;

  TravelProvider() {
    _listenToTravels();
  }

  void _listenToTravels() {
    List<String> keys = [];
    String uid = usuarioLogado!.uid;
    _travelStream = _db.child(uid + TRAVEL_PATH).onValue.listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      keys.addAll(allTravels.keys);
      _travel = allTravels.values
          .map((travelAsJSON) =>
              Travel.fromRTDB(Map<String, dynamic>.from(travelAsJSON)))
          .toList();
      for(int i = 0;i<_travel.length;i++){
        Travel travel = _travel[i];
        travel.setKeys(keys[i]);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _travelStream.cancel();
    super.dispose();
  }
}
