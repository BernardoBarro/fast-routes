import 'package:flutter/material.dart';

class PageMyAddress extends StatefulWidget {
  const PageMyAddress({Key? key}) : super(key: key);

  @override
  State<PageMyAddress> createState() => _PageMyAddressState();
}

class _PageMyAddressState extends State<PageMyAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(children: [
              TextField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 25,
                ),
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(51, 101, 229, 1),
            onPressed: () {},
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
