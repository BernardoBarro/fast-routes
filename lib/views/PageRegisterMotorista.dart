// ignore_for_file: unnecessary_const

import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/PageRegisterPassageiro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fast_routes/views/PageRegisterMotorista.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PageRegisterMotorista extends StatefulWidget {
  const PageRegisterMotorista({Key? key}) : super(key: key);

  @override
  State<PageRegisterMotorista> createState() => _PageRegisterMotoristaState();
}

class _PageRegisterMotoristaState extends State<PageRegisterMotorista> {
  bool motorista = true;
  bool passageiro = false;
  bool feminino = false;
  bool masculino = true;
  var maskPhone = MaskTextInputFormatter(mask: '(##) #####-####');
  var maskCPF = MaskTextInputFormatter(mask: '###.###.###-##');
  var maskDate = MaskTextInputFormatter(mask: '##/##/####');
  bool _showPassword = false;

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerDataNascimento = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = "";

  String _formatDate(date) {
    var dateFormat = new DateFormat('yyyy-MM-dd');
    String dataFormatada = dateFormat.format(date);
    return dataFormatada;
  }

    //_validateFieldsMotorista(String nome, String cpf, String telefone, String dataNascimento, String email, String senha)
    _validateFieldsMotorista(String nome, String cpf, String telefone, String dataNascimento,
        String email, String senha) {

        //String dataFormatada = _formatDate(dataNascimento);
    //validator
      // if(motorista == true) {
      //   if(nome.isNotEmpty) {
      //     if(cpf.isNotEmpty && cpf.length == 11) {
      //       if(telefone.isNotEmpty) {
      //         if(dataNascimento.isNotEmpty) {
      //           if(email.isNotEmpty && email.contains("@")) {
      //             if(senha.isNotEmpty && senha.length >= 6) {
                    _registerMotorista(nome, cpf, telefone, dataNascimento, email, senha);
      //             } else {
      //               _mensagemErro = "Erro";
      //             }
      //           }
      //         }
      //       }
      //     }
      //   }
      // }
    }

  _registerMotorista(String nome, String cpf, String telefone, String dataNascimento,
                    String email, String senha) {
      FirebaseDatabase db = FirebaseDatabase.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      Map<String, dynamic> dataMotorista = {
        'nome':nome,
        'cpf':cpf,
        'telefone':telefone,
        'data_de_nascimento':dataNascimento,
        'email':email,
        'senha':senha, 
        'motorista':motorista,
        'masculino':masculino,
        'feminino':feminino
      };
      
      auth.createUserWithEmailAndPassword(email: email, password: senha)
      .then((firebaseUser) => {
        db
        .ref("usuarios")
        .child(firebaseUser.user!.uid)
        .set(dataMotorista),
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: ((context) => const LoginandRegister())), (route) => false)
      }).catchError((error) {
        setState(() {
          _mensagemErro = "Erro ao criar usuário $error";
        });
      });
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PageRegisterPassageiro()));
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
                controller: _controllerNome,
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
                controller: _controllerCPF,
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
                controller: _controllerTelefone,
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
                controller: _controllerDataNascimento,
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
                controller: _controllerEmail,
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
                controller: _controllerSenha,
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
                height: 20.0,
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
                height: 60.0,
              ),

              //BUTTON
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(51, 101, 229, 1),
                      onPrimary: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {
                      _validateFieldsMotorista(
                        _controllerNome.text,
                        _controllerCPF.text,
                        _controllerTelefone.text,
                        _controllerDataNascimento.text,                     
                        _controllerEmail.text,
                        _controllerSenha.text
                      );
                    },
                    child: Text(
                      "ENVIAR",
                      style: TextStyle(
                        fontFamily: 'InriaSans',
                      ),
                    ),
                  )),
            Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          )),
        ),
      ),
    );
  }
}
