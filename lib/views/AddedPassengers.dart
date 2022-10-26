// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AddedPassengers extends StatefulWidget {
  const AddedPassengers({Key? key}) : super(key: key);

  @override
  State<AddedPassengers> createState() => _AddedPassengersState();
}

TextEditingController editingController = TextEditingController();

class _AddedPassengersState extends State<AddedPassengers> {
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextField(
                      onChanged: (text) {},
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
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
