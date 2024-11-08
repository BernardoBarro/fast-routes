// ignore_for_file: unnecessary_const

import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fast_routes/views/PageRegisterMotorista.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:email_validator/email_validator.dart';

class PageRegisterPassageiro extends StatefulWidget {
  const PageRegisterPassageiro({Key? key}) : super(key: key);

  @override
  State<PageRegisterPassageiro> createState() => _PageRegisterPassageiroState();
}

class _PageRegisterPassageiroState extends State<PageRegisterPassageiro> {
  bool motorista = false;
  bool passageiro = true;
  bool feminino = false;
  bool masculino = true;
  bool pcd = false;
  bool fieldPCD = false;
  var maskPhone = MaskTextInputFormatter(mask: '(##) #####-####');
  var maskCPF = MaskTextInputFormatter(mask: '###.###.###-##');
  var maskDate = MaskTextInputFormatter(mask: '##/##/####');
  bool _showPassword = false;
  bool _showRepeatedPassword = false;

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerDataNascimento = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerRepetirSenha = TextEditingController();
  String _mensagemErro = " ";
  final formKey = GlobalKey<FormState>();

  _registerPassageiro(String nome, String cpf, String telefone,
      String dataNascimento, String email, String senha,
      String endereco) {
    FirebaseDatabase db = FirebaseDatabase.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    Map<String, dynamic> dataPassageiro = {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'data_de_nascimento': dataNascimento,
      'email': email,
      'senha': senha,
      'pcd': pcd,
      'isMotorista': motorista,
      'masculino': masculino,
      'feminino': feminino,
    };

    Map<String, dynamic> dataPassageiroReplica = {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'data_de_nascimento': dataNascimento,
      'email': email,
      'pcd': pcd,
    };

    Map<String, dynamic> EnderecoPassageiro = {
      'endereco' : endereco,
    };

    auth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) => {
              db
                  .ref("usuarios")
                  .child(firebaseUser.user!.uid)
                  .set(dataPassageiro)
                  .then((value) => db
                  .ref("usuarios")
                  .child(firebaseUser.user!.uid)
                  .child("endereco")
                  .push()
                  .set(EnderecoPassageiro),),
              db
                  .ref("passageiros")
                  .child(firebaseUser.user!.uid)
                  .set(dataPassageiroReplica),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const LoginandRegister())),
                  (route) => false)
            })
        .catchError((error) {
      setState(() {
            if(error.code.toString() == "email-already-in-use") {
            setState(() {
              _mensagemErro = "E-mail já cadastrado";
              print(error.toString());
            });
          } else {
            setState(() {
              _mensagemErro = "ocorreu um erro: $error";
            });
          }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables

    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      toolbarHeight: 65,
      backgroundColor: Color.fromARGB(223, 69, 69, 85),
      elevation: 2,
      title: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text("Cadastro Passageiro",),
      ),
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
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: Form(
              key: formKey,
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
                    controller: _controllerNome,
                    validator: (nome) {
                      if (nome == null || nome.isEmpty) {
                        return 'Digite seu nome';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //Style Label
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
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
                    validator: (cpf) {
                      if (cpf == null || cpf.isEmpty) {
                        return 'Digite o seu CPF';
                      } else if (cpf.length != 14) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
                    inputFormatters: [maskCPF],
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //Style Label
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
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
                    validator: (telefone) {
                      if (telefone == null || telefone.isEmpty) {
                        return 'Digite o seu telefone';
                      } else if (telefone.length != 15) {
                        return 'Telefone inválido';
                      }
                      return null;
                    },
                    inputFormatters: [maskPhone],
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //Style Label
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
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
                    validator: (dataNascimento) {
                      if (dataNascimento == null || dataNascimento.isEmpty) {
                        return 'Digite sua data de nascimento';
                      } else if(dataNascimento.length < 10) {
                        return 'Data de nascimento inválida';
                      }
                      return null;
                    },
                    inputFormatters: [maskDate],
                    keyboardType: TextInputType.number,
  

                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //Style Label
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
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

                  //TEXT ENDERECO
                  TextFormField(
                    controller: _controllerEndereco,
                    validator: (endereco) {
                      if (endereco == null || endereco.isEmpty) {
                        return 'Digite seu endereço';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),

                      //Labels
                      labelText: "Endereço",
                      hintText: "Rua, Número, Cidade",

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
                    ),
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

                  const SizedBox(
                    height: 20.0,
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
                    ),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  //TEXT SENHA
                  TextFormField(
                    controller: _controllerSenha,
                    validator: (senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Digite uma senha';
                      } else if (senha.length < 6) {
                        return 'Digite uma senha com mais de 6 caracteres';
                      }
                      return null;
                    },
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
                    ),
                    obscureText: _showPassword == false ? true : false,
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  //TEXT REPETIR SENHA
                  TextFormField(
                    controller: _controllerRepetirSenha,
                    validator: (repetirSenha) {
                      if (repetirSenha == null || repetirSenha.isEmpty) {
                        return 'Digite uma senha';
                      } else if (repetirSenha.length < 6) {
                        return 'Digite uma senha com mais de 6 caracteres';
                      } else if(repetirSenha != _controllerSenha.text) {
                        return 'As senhas são diferentes';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),

                      //Label Senha
                      labelText: "Repetir Senha",
                      hintText: "Digite sua senha",

                      suffixIcon: GestureDetector(
                        child: Icon(
                          _showRepeatedPassword == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color.fromRGBO(170, 170, 170, 1),
                        ),
                        onTap: () {
                          setState(() {
                            _showRepeatedPassword = !_showRepeatedPassword;
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
                    obscureText: _showRepeatedPassword == false ? true : false,
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
                  Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
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
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () {
                          setState(() {
                            _mensagemErro = "";
                          });                            
                            if (formKey.currentState!.validate()) {
                              _registerPassageiro(
                                _controllerNome.text,
                                _controllerCPF.text,
                                _controllerTelefone.text,
                                _controllerDataNascimento.text,
                                _controllerEmail.text,
                                _controllerSenha.text,
                                _controllerEndereco.text);
                            }
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
              ))),
        ),
      ),
    );
  }
}
