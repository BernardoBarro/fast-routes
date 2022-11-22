import 'package:geocoding/geocoding.dart';
import 'package:fast_routes/models/Invite.dart';
import 'package:fast_routes/providers/InviteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteSideBar extends StatefulWidget {
  const InviteSideBar({Key? key}) : super(key: key);

  @override
  State<InviteSideBar> createState() => _InviteSideBarState();
}

class _InviteSideBarState extends State<InviteSideBar> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromRGBO(69, 69, 85, 1),
      padding: const EdgeInsets.only(top: 0, right: 16, left: 16),
      child: Column(
        children: [  
          Consumer<InviteProvider>(builder: (context, model, child) {
            return Expanded(
                child: ListView(
              children: [
                    SizedBox(
                      height: 100,
                      child: const DrawerHeader(
        child: Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: Text('Notificações',textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
        ),
      ),
                    ),
                ...model.invites.map(
                  (invite) => Card(
                    color: Color.fromRGBO(69, 69, 85, 0.8),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 15.0),
                      child: ListTile(
                        title: Text(invite.travelName,style: TextStyle(color: Colors.white),),
                        subtitle: Text(invite.passagerName, style: TextStyle(color: Color.fromARGB(174, 255, 255, 255)),),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: Color.fromARGB(223, 69, 69, 85),
                                  title: const Text("Confirmação!!",style: TextStyle(color: Colors.white),),
                                  content: Text("O " +
                                      invite.passagerName +
                                      " gostaria de entrar na viagem " +
                                      invite.travelName,style: TextStyle(color: Colors.white)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          deleteInvite(invite);
                                        },
                                        child: Text("Recusar",style: TextStyle(color: Colors.white))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.of(context).pop();
                                          _onButtonPressed(invite);
                                        },
                                        child: Text("Aceitar",style: TextStyle(color: Colors.white))),
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
            
          }
          
          )
        ],
      ),
    ));
  }

  void _onButtonPressed(Invite invite) {
    Map<String, dynamic> passageiro = {
      'nome': invite.passagerName,
    };

    Map<String, dynamic> viagem = {
      'weekDays': invite.travelWeekDays,
      'nome': invite.travelName,
      'driverUid': invite.driverUid
    };
    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("viagens")
        .child(invite.travelKey)
        .child("passageiros")
        .child(invite.passagerUid)
        .set(passageiro);

    db
        .ref("usuarios")
        .child(invite.passagerUid)
        .child("viagens")
        .child(invite.travelKey)
        .set(viagem);
    deleteInvite(invite);
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
