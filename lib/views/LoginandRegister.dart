import 'package:fast_routes/views/PageHome.dart';
import 'package:flutter/material.dart';
import 'package:fast_routes/views/PageLogin.dart';
import 'package:fast_routes/views/PageRegisterMotorista.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginandRegister extends StatefulWidget {
  const LoginandRegister({Key? key}) : super(key: key);

  @override
  State<LoginandRegister> createState() => _LoginandRegisterState();
}

class _LoginandRegisterState extends State<LoginandRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(16),
            height: double.infinity,
            width: double.infinity,
            color: Color.fromRGBO(69, 69, 85, 1),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 100.0, left: 16.0, right: 16.0, bottom: 150.0),
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, left: 16.0, right: 16.0, bottom: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            elevation: 0,
                            fixedSize: Size(300.0, 50.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PageLogin()));
                          },
                          child: Text("ENTRAR",
                              style: TextStyle(
                                fontFamily: 'InriaSans',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 16.0, right: 16.0, bottom: 0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            elevation: 0,
                            fixedSize: Size(300.0, 50.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PageRegisterMotorista()));
                          },
                          child: Text(
                            "CADASTRAR",
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
