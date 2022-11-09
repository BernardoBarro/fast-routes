import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Invite.dart';

class InviteProvider extends ChangeNotifier {
  List<Invite> _invites = [];
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final _db = FirebaseDatabase.instance.ref("usuarios");

  static const INVITE_PATH = '/convites';

  late StreamSubscription<DatabaseEvent> _inviteStream;

  List<Invite> get invites => _invites;

  InviteProvider() {
    _listenToInvites();
  }

  void _listenToInvites() {
    List<String> keys = [];
    String uid = usuarioLogado!.uid;
    _inviteStream = _db.child(uid + INVITE_PATH).onValue.listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      keys.addAll(allTravels.keys);
      _invites = allTravels.values
          .map((travelAsJSON) =>
              Invite.fromRTDB(Map<String, dynamic>.from(travelAsJSON)))
          .toList();
      for(int i = 0;i<_invites.length;i++){
        Invite travel = _invites[i];
        travel.setKeys(keys[i]);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _inviteStream.cancel();
    super.dispose();
  }
}
