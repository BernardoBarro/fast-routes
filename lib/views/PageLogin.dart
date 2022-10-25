// ignore_for_file: deprecated_member_use

import 'dart:ffi';

import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/PageHome.dart';
import 'package:fast_routes/views/PageResetPassword.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _showPassword = false;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _mensagemErro = "";
  final formKey = GlobalKey<FormState>();

  _login() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length >= 6) {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageHome()));
                  }),
                });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(69, 69, 85, 1),
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 0, left: 32, right: 32),
            color: Color.fromRGBO(69, 69, 85, 1),
            child: Form(
              key: formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 60, left: 32, right: 32),
                  child: SizedBox(
                    width: 280,
                    height: 250,
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                //TEXT EMAIL
                TextFormField(
                  controller: _controllerEmail,
                  // autofocus: true,
                  validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Digite o seu E-mail';
                      } else if (!EmailValidator.validate(email)) {
                        return 'E-mail inválido';
                      }
                      //Verify email alredy in use
                      return null;
                    },
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
                //TEXT PASSWORD
                TextFormField(
                  controller: _controllerPassword,
                  // autofocus: true,
                  validator: (senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Digite uma senha';
                      } else if (senha.length < 6) {
                        return 'Digite uma senha com mais de 6 caracteres';
                      }
                      return null;
                    },
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                PageResetPassword()));
                    },
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _login;
                        }
                      },
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
        ))
      );
  }
}
