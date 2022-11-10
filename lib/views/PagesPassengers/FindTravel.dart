// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/Travel.dart';


class FindTravel extends StatefulWidget {
  final String chave;
  final String nome;
  const FindTravel(this.chave, this.nome, {Key? key}) : super(key: key);

  @override
  State<FindTravel> createState() => _FindTravelState();
}

TextEditingController editingController = TextEditingController();

class _FindTravelState extends State<FindTravel> {
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final db = FirebaseDatabase.instance;
  static List<Travel> travelList = [];

  List<Travel> displayList = List.from(travelList);

  void updateList(String value) {
    getPassagers();
    setState(() {
      displayList = travelList
          .where((element) =>
              element.nome.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

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
        child: Text("Escolher Viagem",),
      ),),
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
                      labelText: "Escolha a viagem que deseja entrar",
                      hintText: "Informe o nome da viagem",
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
                                    backgroundColor: Color.fromARGB(223, 69, 69, 85),
                                    title: const Text("Confirmação!!", style: TextStyle(color: Colors.white,)),
                                    content: Text("Realmente deseja entrar na viagem " +
                                        displayList[index].nome +
                                        " ?", style: TextStyle(color: Colors.white,)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Não", style: TextStyle(color: Colors.white,))),
                                      TextButton(
                                          onPressed: () {
                                            db.ref("usuarios")
                                              .child(usuarioLogado!.uid)
                                              .child("nome")
                                              .get()
                                              .then((snapshot) {
                                                String nome = (snapshot.value as dynamic);
                                                Map<String, dynamic> invite = {
                                                  'travelName': displayList[index].nome,
                                                  'travelWeekDays': displayList[index].weekDays,
                                                  'travelKey': displayList[index].key,
                                                  'driverUid': widget.chave,
                                                  'passagerUid': usuarioLogado!.uid,
                                                  'passagerName': nome
                                                };
                                                db.ref("usuarios")
                                                    .child(widget.chave)
                                                    .child("convites")
                                                    .push()
                                                    .set(invite);
                                            });
                                            Navigator.of(ctx)
                                                .pop();
                                          }, child: Text("Sim", style: TextStyle(color: Colors.white,))),
                                    ],
                                  );
                                });
                          },
                          title: Text(
                            displayList[index].nome,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            displayList[index].weekDays,
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
    db.ref("usuarios").child(widget.chave).child("viagens").onValue.listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      keys.addAll(allTravels.keys);
      travelList = allTravels.values
          .map((travelAsJSON) => Travel.fromRTDB(
              Map<String, dynamic>.from(travelAsJSON)))
          .toList();
      for(int i = 0;i<travelList.length;i++){
        Travel travel = travelList[i];
        travel.setKeys(keys[i]);
      }
    });
  }
}
