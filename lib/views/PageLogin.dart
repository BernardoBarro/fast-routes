// ignore_for_file: deprecated_member_use

import 'dart:ffi';

import 'package:flutter/material.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 60, left: 32, right: 32),
        color: Color.fromRGBO(69, 69, 85, 1),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 280,
              height: 280,
              child: Image.asset(
                "assets/images/logo.png",
              ),
            ),
            SizedBox(
              height: 55,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(

                  //STYLE BORDER
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(170, 170, 170, 1),
                  )),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(170, 170, 170, 1),
                  )),

                  //LABELS
                  labelText: "E-mail",
                  hintText: "Ex: email@email.com",

                  //Style icon
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromRGBO(170, 170, 170, 1),
                  ),

                  //Style Label
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(170, 170, 170, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  //Style Hint
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.streetAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(

                  //STYLE BORDER
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(170, 170, 170, 1),
                  )),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(170, 170, 170, 1),
                  )),

                  //LABELS
                  labelText: "Senha",
                  suffixIcon: GestureDetector(
                    child: Icon(
                      _showPassword == false
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ),
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  //Style icon
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color.fromRGBO(170, 170, 170, 1),
                  ),

                  //Style Label
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(170, 170, 170, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  )),

              obscureText: _showPassword == false ? true : false,
            ),
            //Esqueceu a senha
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Esqueceu sua senha?",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(
              height: 45,
            ),

            //BUTTON
            SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(51, 101, 229, 1),
                    onPrimary: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Text(
                    "ENTRAR",
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                    ),
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
