import 'package:flutter/material.dart';
import 'package:fast_routes/views/PageLogin.dart';
import 'package:fast_routes/views/PageRegisterMotorista.dart';

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
        color: Color.fromRGBO(57, 57, 57, 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 16.0, right: 16.0, bottom: 30.0),
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
                width: 350,
                height: 450,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 35.0, left: 16.0, right: 16.0, bottom: 15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(51, 101, 229, 1),
                  onPrimary: Colors.white,
                  elevation: 0,
                  fixedSize: Size(200.0, 50.0),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PageLogin()));
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
                  primary: Color.fromRGBO(51, 101, 229, 1),
                  onPrimary: Colors.white,
                  elevation: 0,
                  fixedSize: Size(200.0, 50.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageRegisterMotorista()));
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
    ));
  }
}
