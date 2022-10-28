import 'package:flutter/material.dart';

class PageConfig extends StatefulWidget {
  const PageConfig({Key? key}) : super(key: key);

  @override
  State<PageConfig> createState() => _PageConfigState();
}

class _PageConfigState extends State<PageConfig> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 69, 85, 1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Alterar seu e-mail",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 12,
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
                height: 50,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Alterar sua senha",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
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
              //Esqueceu a s
            ]),
          ),
        ),
      ),
    );
  }
}
