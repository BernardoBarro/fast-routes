import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/PageLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    setState(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginandRegister()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(7),
                child: ElevatedButton(
                  onPressed: _logout,
                  child: Text("Sair"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
