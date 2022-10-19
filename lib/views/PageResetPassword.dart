import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/PageRegisterMotorista.dart';
import 'package:fast_routes/views/Utils.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PageResetPassword extends StatefulWidget {
  const PageResetPassword({Key? key}) : super(key: key);

  @override
  State<PageResetPassword> createState() => _PageResetPasswordState();
}

class _PageResetPasswordState extends State<PageResetPassword> {
  TextEditingController _controllerEmail = TextEditingController();
  String _mensagemErro = "";
  final formKey = GlobalKey<FormState>();

  _resetPassword(String emailField) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: ((context) => Center(child: CircularProgressIndicator())));

    FirebaseAuth auth = FirebaseAuth.instance;
      auth
        .sendPasswordResetEmail(email: emailField)
        .then((value) => {
          setState(() {
            _mensagemErro = "";
          }),
          Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const LoginandRegister())),
                  (route) => false),
          // show toast              
        })
        .catchError((error) {
          if(error.code.toString() == "user-not-found") {
                setState(() {
                  _mensagemErro = "E-mail não encontrado";
                  print(error.toString());
                });
            } else {
                setState(() {
                  _mensagemErro = "ocorreu um erro: $error";
                });
              }                
        });
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
                      width: 200,
                      height: 180,
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60, left: 32, right: 32),
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: Text(
                        "Insira o seu e-mail para mudar sua senha",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //TEXT EMAIL
                  TextFormField(
                    controller: _controllerEmail,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Digite o seu E-mail';
                      } else if (!EmailValidator.validate(email)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
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
                    height: 15,
                  ),
                  //MESSAGE ERROR
                  Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                          setState(() {
                            _mensagemErro = "";
                          });
                          if (formKey.currentState!.validate()) {
                            print("form validado");
                            _resetPassword(
                              _controllerEmail.text);
                          }
                        },
                        child: Text(
                          "ENVIAR",
                          style: TextStyle(
                            fontFamily: 'InriaSans',
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
