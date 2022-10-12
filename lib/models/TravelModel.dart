import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Travel.dart';

class TravelModel extends ChangeNotifier {
  List<Travel> _travel = [];
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  static const TRAVEL_PATH = '/viagens';

  late StreamSubscription<DatabaseEvent> _travelStream;

  List<Travel> get travels => _travel;

  TravelModel() {
    _listenToTravels();
  }

  void _listenToTravels() {
    String uid = usuarioLogado!.uid;
    _travelStream = _db.child(uid+TRAVEL_PATH).onValue.listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _travel = allTravels.values
          .map((travelAsJSON) =>
              Travel.fromRTDB(Map<String, dynamic>.from(travelAsJSON)))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _travelStream.cancel();
    super.dispose();
  }
}
