import 'package:fast_routes/models/Travel.dart';
import 'package:fast_routes/views/PagesPassengers/FindDriver.dart';
import 'package:fast_routes/views/PagesPassengers/PageHomePassenger.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/TravelProvider.dart';

class PageMyAddress extends StatefulWidget {
  const PageMyAddress({Key? key}) : super(key: key);

  @override
  State<PageMyAddress> createState() => _PageMyAddressState();
}

class _PageMyAddressState extends State<PageMyAddress> {
  final db = FirebaseDatabase.instance.ref("usuarios");
  User? usuarioLogado = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(223, 69, 69, 85),
        elevation: 2,
        title: Padding(
          padding: const EdgeInsets.only(top: .0),
          child: Text(
            "Minhas Viagens",
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: Column(
            children: [
              Consumer<TravelProvider>(builder: (context, model, child) {
                return Expanded(
                    child: ListView(
                  children: [
                    ...model.travels.map(
                      (travel) => Row(
                        children: [
                          Container(
                              width: 250,
                              height: 80,
                              child: Card(
                                color: travel.viagemIniciada
                                    ? Colors.blue
                                    : Color.fromARGB(227, 108, 108, 126),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    if (travel.viagemIniciada) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PageHomePassenger(
                                                      chaveViagem: travel.key,
                                                      chaveMotorista:
                                                          travel.driverUid,
                                                      false)));
                                    }
                                  },
                                  child: SizedBox(
                                    width: 350,
                                    height: 100,
                                    child: Center(
                                      child: ListTile(
                                        trailing: Builder(
                                          builder: (BuildContext context) {
                                            return IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                showAlertDialog(
                                                    context, travel);
                                              },
                                            );
                                          },
                                        ),
                                        textColor:
                                            Color.fromRGBO(255, 255, 255, 1),
                                        title: Text(
                                          travel.nome,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        subtitle: Text(
                                          travel.weekDays,
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.6,
                                              color: Color.fromARGB(
                                                  174, 255, 255, 255)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Container(
                              height: 35,
                              width: 80,
                              child: LiteRollingSwitch(
                                width: 80,
                                iconOn: Icons.check,
                                iconOff: Icons.remove,
                                colorOn: Colors.green,
                                colorOff: Colors.red,
                                textOff: "",
                                textOn: "",
                                animationDuration: Duration(milliseconds: 0),
                                onChanged: (bool state) {
                                  db
                                      .child(travel.driverUid)
                                      .child("viagens")
                                      .child(travel.key)
                                      .child("passageiros")
                                      .child(usuarioLogado!.uid)
                                      .child("participa")
                                      .set(state);
                                },
                                onSwipe: () {},
                                onDoubleTap: () {},
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ));
              })
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FindDriver()));
            },
            child: Icon(
              Icons.add,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, Travel travel) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(223, 69, 69, 85),
            title: const Text("Confirmação!!",
                style: TextStyle(color: Colors.white)),
            content: Text(
              "Você tem certeza que deseja sair da viagem: " +
                  travel.nome +
                  "?",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Não", style: TextStyle(color: Colors.white))),
              TextButton(
                  onPressed: () {
                    removeTravel(travel);
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Sim", style: TextStyle(color: Colors.white))),
            ],
          );
        });
  }

  void removeTravel(Travel travel) {
    print(travel.driverUid);
    db.child(usuarioLogado!.uid).child('viagens').child(travel.key).remove();
    db
        .child(travel.driverUid)
        .child('viagens')
        .child(travel.key)
        .child("passageiros")
        .child(usuarioLogado!.uid)
        .remove();
  }
}
