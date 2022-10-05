import 'package:flutter/material.dart';

class PageViagens extends StatefulWidget {
  const PageViagens({Key? key}) : super(key: key);

  @override
  State<PageViagens> createState() => _PageViagensState();
}

class _PageViagensState extends State<PageViagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromARGB(255, 2, 69, 255),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(),
          ),
        ),
      ),
    );
  }
}
