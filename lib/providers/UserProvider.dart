import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Customer.dart';

class UserProvider extends ChangeNotifier {
  late Customer _user;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  late StreamSubscription<DatabaseEvent> _userStream;

  Customer get user => _user;

  UserProvider() {
    _listenToUser();
  }

  void _listenToUser() {
    String uid = usuarioLogado!.uid;
    _userStream = _db.child(uid).onValue.listen((event) {
      final user = Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _user = Customer.fromRTDB(
          Map<String, dynamic>.from(user));
      _user.setKeys(uid);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userStream.cancel();
    super.dispose();
  }
}
