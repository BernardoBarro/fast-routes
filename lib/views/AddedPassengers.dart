// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/Customer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Travel.dart';

class AddedPassengers extends StatefulWidget {
  final String chave;
  const AddedPassengers(this.chave, {Key? key}) : super(key: key);

  @override
  State<AddedPassengers> createState() => _AddedPassengersState();
}

TextEditingController editingController = TextEditingController();

class _AddedPassengersState extends State<AddedPassengers> {
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final db = FirebaseDatabase.instance;
  static List<Customer> passageirosList = [];

  List<Customer> displayList = List.from(passageirosList);

  void updateList(String value) {
    getPassagers();
    setState(() {
      displayList = passageirosList
          .where((element) =>
              element.nome.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(69, 69, 85, 1),
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromRGBO(69, 69, 85, 1),
            padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => updateList(value),
                    controller: editingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      //Style Label
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),

                      //Style Hint
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      labelText: "Procurar passageiros",
                      hintText: "Informe o nome do passageiro",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          )),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        border: Border.all(color: Colors.white),
                      ),
                      child: ListView.builder(
                        itemCount: displayList.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text("Confirmação!"),
                                    content: Text("Realmente deseja convidar " +
                                        displayList[index].nome +
                                        " para a sua viagem?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Não")),
                                      TextButton(
                                          onPressed: () {
                                            db.ref("usuarios")
                                              .child(usuarioLogado!.uid)
                                              .child("nome")
                                              .get()
                                              .then((snapshot) {
                                                String nome = (snapshot.value as dynamic);
                                                db.ref("usuarios")
                                                    .child(usuarioLogado!.uid)
                                                    .child("viagens")
                                                    .child(widget.chave)
                                                    .get()
                                                    .then((snapshot) {
                                                      Travel travel = Travel.fromRTDB(Map<String, dynamic>.from((snapshot.value as dynamic)));
                                                      Map<String, dynamic> invite = {
                                                        'travelName': travel.nome,
                                                        'travelWeekDays': travel.weekDays,
                                                        'travelKey': snapshot.key,
                                                        'driverName': nome,
                                                        'driverUid': usuarioLogado!.uid,
                                                        'passagerUid': displayList[index]!.uid
                                                      };
                                                      print(invite);
                                                    db.ref("usuarios")
                                                        .child(displayList[index]!.uid)
                                                        .child("convites")
                                                        .push()
                                                        .set(invite);
                                                });
                                            });
                                            Navigator.of(ctx)
                                                .pop();
                                          }, child: Text("Sim")),
                                    ],
                                  );
                                });
                          },
                          title: Text(
                            displayList[index].nome,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            displayList[index].email,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.6)),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void getPassagers() {
    List<String> keys = [];
    db.ref("passageiros").onValue.listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      keys.addAll(allTravels.keys);
      passageirosList = allTravels.values
          .map((travelAsJSON) => Customer.fromRTDB(
              Map<String, dynamic>.from(travelAsJSON)))
          .toList();
      for(int i = 0;i<passageirosList.length;i++){
        Customer travel = passageirosList[i];
        travel.setKeys(keys[i]);
      }
    });
  }
}
