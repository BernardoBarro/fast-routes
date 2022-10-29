// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../models/Customer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddedPassengers extends StatefulWidget {
  const AddedPassengers({Key? key}) : super(key: key);

  @override
  State<AddedPassengers> createState() => _AddedPassengersState();
}

TextEditingController editingController = TextEditingController();

class _AddedPassengersState extends State<AddedPassengers> {
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final db = FirebaseDatabase.instance.ref("passageiros");
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
                  SizedBox(height: 20.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(displayList[index].nome),
                        subtitle: Text(displayList[index].email),
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
    db.onValue.listen((event) {
      final allTravels =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      passageirosList = allTravels.values
          .map((travelAsJSON) => Customer.fromRTDB(
              Map<String, dynamic>.from(travelAsJSON), usuarioLogado!.uid))
          .toList();
    });
  }
}
