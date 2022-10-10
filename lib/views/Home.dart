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
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(7),
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