import 'package:fast_routes/models/Customer.dart';
import 'package:fast_routes/views/AddedPassengers.dart';
import 'package:fast_routes/views/PageHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../providers/TravelPassagerProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ListPassengers extends StatefulWidget {
  final String chave;

  const ListPassengers(this.chave, {Key? key}) : super(key: key);

  @override
  State<ListPassengers> createState() => _ListPassengersState();
}

class _ListPassengersState extends State<ListPassengers> {
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final db = FirebaseDatabase.instance.ref("usuarios");
  bool participa = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 65,
        backgroundColor: Color.fromARGB(223, 69, 69, 85),
        elevation: 2,
        title: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            "Lista de Passageiros",
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
          child: Column(
            children: [
              Text(
                'Lista de Passageiros',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 25),
              ),
              SizedBox(
                height: 15.0,
              ),
              Consumer<TravelPassagerProvider>(
                  builder: (context, model, child) {
                return Text(
                  model.singleTravel.nome + " - " + model.singleTravel.weekDays,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                );
              }),
              SizedBox(
                height: 50.0,
              ),
              Consumer<TravelPassagerProvider>(
                  builder: (context, model, child) {
                bool forAndroid = true;
                return Expanded(
                  child: ListView(
                    children: [
                      ...model.passageiros.map(
                        (passageiro) => Row(
                          children: [
                            Container(
                              width: 250,
                              height: 50,
                              child: Card(
                                color: Color.fromRGBO(69, 69, 85, 0.8),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 15.0),
                                  child: Text(
                                    passageiro.nome,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
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
                                  value: passageiro.participa,
                                  onChanged: (bool state) {
                                    updatePassagers()
                                        .child(passageiro.uid)
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
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 100.0,
        width: 60.0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.blue,
            overlayOpacity: 0,
            spaceBetweenChildren: 15,
            childPadding: const EdgeInsets.all(0),
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 30,
                ),
                backgroundColor: Colors.blue,
                label: 'Inciar rota',
                onTap: () {
                  db
                      .child(usuarioLogado!.uid)
                      .child("viagens")
                      .child(widget.chave)
                      .child("viagemIniciada")
                      .set(true);

                  updatePassagers();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PageHome(chaveViagem: widget.chave, false)));
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ),
                backgroundColor: Colors.blue,
                label: 'Adicionar passageiro',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddedPassengers(widget.chave)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  updatePassagers() {
    db
        .child(usuarioLogado!.uid)
        .child("viagens")
        .child(widget.chave)
        .child("passageiros")
        .onValue
        .listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      allTravels.keys.forEach((element) {
        db
            .child(element)
            .child("viagens")
            .child(widget.chave)
            .child("viagemIniciada")
            .set(true);
      });
    });
  }

  getParticipa(Customer passageiro) {
    bool alo = false;
    updatePassagers()
        .child(passageiro.uid)
        .child("participa")
        .get()
        .then((snapshot) => {
              alo = (snapshot.value as dynamic),
            });
    return alo;
  }
}
