import 'package:geocoding/geocoding.dart';
import 'package:fast_routes/models/Invite.dart';
import 'package:fast_routes/providers/InviteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteSideBarPassageiro extends StatefulWidget {
  const InviteSideBarPassageiro({Key? key}) : super(key: key);

  @override
  State<InviteSideBarPassageiro> createState() =>
      _InviteSideBarPassageiroState();
}

class _InviteSideBarPassageiroState extends State<InviteSideBarPassageiro> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromRGBO(69, 69, 85, 1),
      padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
      child: Column(
        children: [
          Consumer<InviteProvider>(builder: (context, model, child) {
            print(model);
            return Expanded(
                child: ListView(
              children: [
                ...model.invites.map(
                  (invite) => Card(
                    color: Color.fromRGBO(69, 69, 85, 0.8),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 15.0),
                      child: ListTile(
                        title: Text(invite.travelName),
                        subtitle: Text(invite.driverName),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("Confirmação!"),
                                  content: Text("O motorista " +
                                      invite.driverName +
                                      " está te convidando a entrar na viagem " +
                                      invite.travelName +
                                      " que acontece nos dias " +
                                      invite.travelWeekDays +
                                      ". Gostaria de participar?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          deleteInvite(invite);
                                        },
                                        child: Text("Recusar")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.of(context).pop();
                                          _onButtonPressed(invite);
                                        },
                                        child: Text("Aceitar")),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ));
          })
        ],
      ),
    ));
  }

  void _onButtonPressed(Invite invite) {
    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("nome")
        .get()
        .then((snapshot) {
      String nome = (snapshot.value as dynamic);
      Map<String, dynamic> passageiro = {
        'nome': nome,
      };

      Map<String, dynamic> viagem = {
        'weekDays': invite.travelWeekDays,
        'nome': invite.travelName,
        'driverUid': invite.driverUid
      };
      db
          .ref("usuarios")
          .child(invite.driverUid)
          .child("viagens")
          .child(invite.travelKey)
          .child("passageiros")
          .child(invite.passagerUid)
          .set(passageiro);

      db
          .ref("usuarios")
          .child(usuarioLogado!.uid)
          .child("viagens")
          .child(invite.travelKey)
          .set(viagem);
      deleteInvite(invite);
    });
  }

  void deleteInvite(Invite invite) {
    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("convites")
        .child(invite.key)
        .remove();
  }
}
