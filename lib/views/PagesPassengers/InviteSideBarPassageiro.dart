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
      padding: const EdgeInsets.only(top: 0, right: 16, left: 16),
      child: Column(
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
          Consumer<InviteProvider>(builder: (context, model, child) {
            print(model);
            
            return Expanded(
                child: ListView(
              children: [
                
                ...model.invites.map(
                  (invite) => Card(
                    color: Color.fromARGB(227, 108, 108, 126),
                                   elevation: 3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: ListTile(
                        title: Text(invite.travelName,style: TextStyle(color: Colors.white),),
                        subtitle: Text(invite.driverName,style: TextStyle(color: Color.fromARGB(174, 255, 255, 255))),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: Color.fromARGB(223, 69, 69, 85),
                                  title: const Text("Confirmação!",style: TextStyle(color: Colors.white),),
                                  content: Text("O motorista " +
                                      invite.driverName +
                                      " está te convidando a entrar na viagem " +
                                      invite.travelName +
                                      " que acontece nos dias " +
                                      invite.travelWeekDays +
                                      ". Gostaria de participar?",style: TextStyle(color: Colors.white),),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          deleteInvite(invite);
                                        },
                                        child: Text("Recusar",style: TextStyle(color: Colors.white),)),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.of(context).pop();
                                          _onButtonPressed(invite);
                                        },
                                        child: Text("Aceitar",style: TextStyle(color: Colors.white),)),
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
        'origem': true,
        'participa': true,
        'destinoLatitude': "",
        'destinoLongitude': "",
        'origemLatitude': "",
        'origemLongitude': "",
      };

      Map<String, dynamic> viagem = {
        'weekDays': invite.travelWeekDays,
        'nome': invite.travelName,
        'driverUid': invite.driverUid,
        'viagemIniciada': false
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
