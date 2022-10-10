import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'PageCreateTravel.dart';

class PageViagens extends StatefulWidget {
  const PageViagens({Key? key}) : super(key: key);

  @override
  State<PageViagens> createState() => _PageViagensState();
}

class _PageViagensState extends State<PageViagens> {
  _pageCreateTravel() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PageCreateTravel()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: Color.fromRGBO(51, 101, 229, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card 1.');
                    },
                    child: SizedBox(
                      width: 350,
                      height: 100,
                      child: Center(
                        child: ListTile(
                          textColor: Color.fromRGBO(255, 255, 255, 1),
                          title: Text(
                            'Viagem URI CAMPUS 2',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Manha,Sab',
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Color.fromARGB(174, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color.fromRGBO(51, 101, 229, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card 2.');
                    },
                    child: SizedBox(
                      width: 350,
                      height: 100,
                      child: Center(
                        child: ListTile(
                          textColor: Color.fromRGBO(255, 255, 255, 1),
                          title: Text(
                            'Viagem URI CAMPUS 1/2',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Tarde,Seg a Sab',
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Color.fromARGB(174, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color.fromRGBO(51, 101, 229, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card 3.');
                    },
                    child: SizedBox(
                      width: 350,
                      height: 100,
                      child: Center(
                        child: ListTile(
                          textColor: Color.fromRGBO(255, 255, 255, 1),
                          title: Text(
                            'Viagem URI CAMPUS 1/2',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Noite,Seg a Sex',
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Color.fromARGB(174, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(51, 101, 229, 1),
            onPressed: _pageCreateTravel,
            child: Icon(
              Icons.add,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}