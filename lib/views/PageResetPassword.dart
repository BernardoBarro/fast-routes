import 'package:flutter/material.dart';

class PageResetPassword extends StatefulWidget {
  const PageResetPassword({Key? key}) : super(key: key);

  @override
  State<PageResetPassword> createState() => _PageResetPasswordState();
}

class _PageResetPasswordState extends State<PageResetPassword> {
  TextEditingController _controllerEmail = TextEditingController();

  _resetPassword(String email) {
    
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
                    child: Text (
                      "Insira o seu e-mail para mudar sua senha",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                  ),                  
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerEmail,
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
                        _resetPassword(_controllerEmail.text);
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
        ));
  }
}
