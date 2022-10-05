import 'package:flutter/material.dart';

class PagePerfil extends StatefulWidget {
  const PagePerfil({Key? key}) : super(key: key);

  @override
  State<PagePerfil> createState() => _PagePerfilState();
}

class _PagePerfilState extends State<PagePerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(),
          ),
        ),
      ),
    );
  }
}
