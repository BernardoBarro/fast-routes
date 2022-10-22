import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ListPassengers extends StatefulWidget {
  const ListPassengers({Key? key}) : super(key: key);

  @override
  State<ListPassengers> createState() => _ListPassengersState();
}

late String nameTravel = 'Viagem URI Campus 1/2, Tarde, Seg a Sex';

class _ListPassengersState extends State<ListPassengers> {
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
          padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Lista de Passageiros',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 22),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  nameTravel,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            ),
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
            backgroundColor: Color.fromRGBO(51, 101, 229, 1),
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
                backgroundColor: Color.fromRGBO(51, 101, 229, 1),
                label: 'Inciar rota',
                onTap: () {
                  print('rota');
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ),
                backgroundColor: Color.fromRGBO(51, 101, 229, 1),
                label: 'Adicionar passageiro',
                onTap: () {
                  print('Added');
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                backgroundColor: Color.fromRGBO(51, 101, 229, 1),
                label: 'Criar PDF',
                onTap: () {
                  print('PDF');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
