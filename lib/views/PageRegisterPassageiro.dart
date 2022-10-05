// ignore_for_file: unnecessary_const

import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fast_routes/views/PageRegisterMotorista.dart';

class PageRegisterPassageiro extends StatefulWidget {
  const PageRegisterPassageiro({Key? key}) : super(key: key);

  @override
  State<PageRegisterPassageiro> createState() => _PageRegisterPassageiroState();
}

class _PageRegisterPassageiroState extends State<PageRegisterPassageiro> {
  bool motorista = false;
  bool passageiro = true;
  bool feminino = false;
  bool masculino = false;
  bool pcd = false;
  bool fieldPCD = false;
  var maskPhone = MaskTextInputFormatter(mask: '(##) #####-####');
  var maskCPF = MaskTextInputFormatter(mask: '###.###.###-##');
  var maskDate = MaskTextInputFormatter(mask: '##/##/####');
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: ((context) => const LoginandRegister())),
                (route) => false);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [Icon(Icons.arrow_back)],
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(69, 69, 85, 1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 0, right: 16, left: 16),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                      side: BorderSide(color: Colors.white),
                      value: motorista,
                      onChanged: (bool? checked) {
                        setState(() {
                          motorista = !motorista;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const PageRegisterMotorista())),
                          );
                        });
                      }),
                  const Text(
                    "Motorista",
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 115.0),
                    child: Checkbox(
                        side: BorderSide(color: Colors.white),
                        value: passageiro,
                        onChanged: (bool? checked) {
                          setState(() {
                            passageiro = !passageiro;
                          });
                        }),
                  ),
                  const Text(
                    "Passageiro",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),

              //TEXT NOME
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  //Style Label
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style Hint
                  hintStyle: const TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),

                  //Labels Nome
                  labelText: "Nome Completo",
                  hintText: "Digite seu nome",
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              //TEXT CPF
              TextFormField(
                inputFormatters: [maskCPF],
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  //Style Label
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style Hint
                  hintStyle: const TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),

                  //Labels Nome
                  labelText: "CPF",
                  hintText: "000.000.000-00",
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              //TEXT TELEFONE
              TextFormField(
                inputFormatters: [maskPhone],
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  //Style Label
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style Hint
                  hintStyle: const TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),

                  //Labels Nome
                  labelText: "Telefone",
                  hintText: "(54) 88888-8888",
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              //TEXT DATA
              TextFormField(
                inputFormatters: [maskDate],
                keyboardType: TextInputType.number,
                //validator: _validateDate,

                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  //Style Label
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style Hint
                  hintStyle: const TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),

                  //Labels Nome
                  labelText: "Data Nascimento",
                  hintText: "DD/MM/AAAA",
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              //TEXT EMAIL
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),

                  //Labels E-mail
                  labelText: "E-mail",
                  hintText: "Ex: email@email.com",

                  //Style Label
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  //Style Hint
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              //TEXT SENHA
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                  //Label Senha
                  labelText: "Senha",
                  hintText: "Digite sua senha",

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

                  //Style Label
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  //Style Hint
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                ),
                obscureText: _showPassword == false ? true : false,
              ),

              const SizedBox(
                height: 10.0,
              ),

              //NECESSIDADE ESPECIAL
              Row(children: [
                Checkbox(
                    side: BorderSide(color: Colors.white),
                    value: pcd,
                    onChanged: (bool? checked) {
                      setState(() {
                        pcd = !pcd;

                        if (pcd == true) {
                          fieldPCD = true;
                        } else if (pcd == false) {
                          fieldPCD = false;
                        }
                      });
                    }),
                const Text(
                  "PCD",
                  style: TextStyle(color: Colors.white),
                ),
              ]),

              TextFormField(
                enabled: fieldPCD,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),

                  //Labels
                  labelText: "Descreva aqui seu tipo de doença",

                  //Style Label
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  //Style borders
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )),
                ),
              ),

              const SizedBox(
                height: 10.0,
              ),

              //ROW MASC FEM
              Row(
                children: [
                  Checkbox(
                      side: BorderSide(color: Colors.white),
                      value: masculino,
                      onChanged: (bool? checked) {
                        setState(() {
                          masculino = !masculino;
                          if (masculino == true) {
                            feminino = false;
                          }
                        });
                      }),
                  const Text(
                    "Masculino",
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 120.0),
                    child: Checkbox(
                        side: BorderSide(color: Colors.white),
                        value: feminino,
                        onChanged: (bool? checked) {
                          setState(() {
                            feminino = !feminino;
                            if (feminino == true) {
                              masculino = false;
                            }
                          });
                        }),
                  ),
                  const Text(
                    "Feminino",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),

              const SizedBox(
                height: 20.0,
              ),

              //BUTTON
              Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(51, 101, 229, 1),
                        onPrimary: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const LoginandRegister())),
                            (route) => false);
                      },
                      child: Text(
                        "ENVIAR",
                        style: TextStyle(
                          fontFamily: 'InriaSans',
                        ),
                      ),
                    ),
                  )),
            ],
          )),
        ),
      ),
    );
  }
}
