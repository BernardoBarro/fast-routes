import 'package:fast_routes/views/PageHome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PageCreateTravel extends StatefulWidget {
  const PageCreateTravel({Key? key}) : super(key: key);

  @override
  State<PageCreateTravel> createState() => _PageCreateTravelState();
}

class _PageCreateTravelState extends State<PageCreateTravel> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerNumPassageiros = TextEditingController();
  TextEditingController _controllerHorarioIda = TextEditingController();
  TextEditingController _controllerOrigemIda = TextEditingController();
  TextEditingController _controllerHorarioVolta = TextEditingController();
  TextEditingController _controllerOrigemVolta = TextEditingController();
  String _mensagemErro = "";
  String _mensagemErroPass = "";
  bool seg = false;
  bool ter = false;
  bool qua = false;
  bool qui = false;
  bool sex = false;
  bool sab = false;
  bool dom = false;
  var maskTime = MaskTextInputFormatter(mask: '##:##');
  final formKey = GlobalKey<FormState>();
  var pass;
  int? passageiros;

  int convert(String text) {
    int casted = int.parse(text);
    return casted;
  }

  String _getDate() {
    var now = new DateTime.now();
    var dateFormat = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String dataFormatada = dateFormat.format(now);
    return dataFormatada;
  }

  _criaViagem(String nome, String numPassageiros, String horarioIda,
      String origemIda, String horarioVolta, String origemVolta) {
    FirebaseDatabase db = FirebaseDatabase.instance;
    User? usuarioLogado = FirebaseAuth.instance.currentUser;
    String dataFormatada = _getDate();

    if (dom == false &&
        seg == false &&
        ter == false &&
        qua == false &&
        qui == false &&
        sex == false &&
        sab == false) {
      setState(() {
        _mensagemErro = "Selecione ao menos um dia";
      });
    } else {
      String days = '';
      if (dom) {
        days += 'Dom ';
      }
      if (seg) {
        days += 'Seg ';
      }
      if (ter) {
        days += 'Ter ';
      }
      if (qua) {
        days += 'Qua ';
      }
      if (qui) {
        days += 'Qui ';
      }
      if (sex) {
        days += 'Sex ';
      }
      if (sab) {
        days += 'Sab ';
      }
      Map<String, dynamic> viagem = {
        'driverUid': usuarioLogado!.uid,
        'nome': nome,
        'numPassageiros': numPassageiros,
        'data': dataFormatada,
        'weekDays': days,
        "ida": {'horario': horarioIda, 'origem': origemIda},
        "volta": {'horario': horarioVolta, 'origem': origemVolta},
        'viagemIniciada': false,
      };

      db
          .ref("usuarios")
          .child(usuarioLogado.uid)
          .child("viagens")
          .push()
          .set(viagem)
          .then((value) => print("Viagem cadastrada com sucesso!"))
          .catchError((error) => print("Ocorreu um erro $error"));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PageHome(false),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      toolbarHeight: 65,
      backgroundColor: Color.fromARGB(223, 69, 69, 85),
      elevation: 2,
      title: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text("Criar Viagem",),
      ),),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50, top: 10),
                    //TEXT NOME
                    child: TextFormField(
                      controller: _controllerNome,
                      validator: (nome) {
                        if (nome == null || nome.isEmpty) {
                          return 'Digite o nome da viagem';
                        }
                        return null;
                      },
                      //autofocus: true,
                      keyboardType: TextInputType.name,
                      autocorrect: false,
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
                        labelText: "Nome da viagem",
                        hintText: "Insira o nome da viagem",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Seg",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: seg,
                              onChanged: (bool? checked) {
                                setState(() {
                                  seg = !seg;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Ter",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: ter,
                              onChanged: (bool? checked) {
                                setState(() {
                                  ter = !ter;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Qua",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: qua,
                              onChanged: (bool? checked) {
                                setState(() {
                                  qua = !qua;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Qui",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: qui,
                              onChanged: (bool? checked) {
                                setState(() {
                                  qui = !qui;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Sex",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: sex,
                              onChanged: (bool? checked) {
                                setState(() {
                                  sex = !sex;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Sáb",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: sab,
                              onChanged: (bool? checked) {
                                setState(() {
                                  sab = !sab;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Dom",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              side: BorderSide(color: Colors.white),
                              value: dom,
                              onChanged: (bool? checked) {
                                setState(() {
                                  dom = !dom;
                                });
                              }),
                        ],
                      ),
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
                    height: 40.0,
                  ),
                  //TEXT NUMERO PASSAGEIROS
                  TextFormField(
                    controller: _controllerNumPassageiros,
                    validator: (passageiros) {
                      if (passageiros == null || passageiros.isEmpty) {
                        return "A viagem precisa ter passageiros";
                      }
                      if (passageiros.length >= 1) {
                        int pass = convert(passageiros.toString());
                        if (pass <= 0) {
                          return "A viagem precisa ter passageiros";
                        }
                      }
                      return null;
                    },
                    //autofocus: true,
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
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
                      labelText: "Número de passageiros",
                      hintText: "Insira o número de passageiros",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //HORÁRIO DE IDA E VOLTA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 13),
                        child: Text(
                          "Horários",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160,
                            //TEXT HORARIO IDA
                            child: TextFormField(
                              controller: _controllerHorarioIda,
                              validator: (horarioIda) {
                                if (horarioIda == null || horarioIda.isEmpty) {
                                  return "Digite o horário de ida";
                                }
                                return null;
                              },
                              autocorrect: false,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [maskTime],
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                //Style Hint
                                hintStyle: const TextStyle(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
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

                                hintText: "Insira o horário de ida",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            //TEXT HORARIO VOLTA
                            child: TextFormField(
                              controller: _controllerHorarioVolta,
                              autocorrect: false,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [maskTime],
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                //Style Hint
                                hintStyle: const TextStyle(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
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

                                hintText: "Insira horário de volta",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 13),
                        child: Text(
                          "Origem",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160,
                            //TEXT ORIGEM IDA
                            child: TextFormField(
                              controller: _controllerOrigemIda,
                              validator: (origemIda) {
                                if (origemIda == null || origemIda.isEmpty) {
                                  return "Digite a origem de ida";
                                }
                                return null;
                              },
                              autocorrect: false,
                              keyboardType: TextInputType.visiblePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                //Style Hint
                                hintStyle: const TextStyle(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
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

                                hintText: "Insira origem de ida",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            //TEXT ORIGEM VOLTA
                            child: TextFormField(
                              controller: _controllerOrigemVolta,
                              autocorrect: false,
                              keyboardType: TextInputType.visiblePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                //Style Hint
                                hintStyle: const TextStyle(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
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

                                hintText: "Insira origem de volta",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 60,
                  ),

                  SizedBox(
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
                          _mensagemErroPass = "";
                        });
                        if (formKey.currentState!.validate()) {
                          _criaViagem(
                              _controllerNome.text,
                              _controllerNumPassageiros.text,
                              _controllerHorarioIda.text,
                              _controllerOrigemIda.text,
                              _controllerHorarioVolta.text,
                              _controllerOrigemVolta.text);
                        }
                      },
                      child: Text(
                        "Criar Viagem",
                        style: TextStyle(
                          fontFamily: 'InriaSans',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
