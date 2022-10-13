import 'package:fast_routes/views/PageHome.dart';
import 'package:fast_routes/views/PagePerfil.dart';
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
  bool seg = false;
  bool ter = false;
  bool qua = false;
  bool qui = false;
  bool sex = false;
  bool sab = false;
  bool dom = false;
  var maskTime = MaskTextInputFormatter(mask: '##:##');

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

    Map<String, dynamic> viagem = {
      'nome': nome,
      'numPassageiros': numPassageiros,
      'data': dataFormatada,
      'dias': {
        'dom': dom,
        'seg': seg,
        'ter': ter,
        'qua': qua,
        'qui': qui,
        'sex': sex,
        'sab': sab
      },
      "ida": {'horario': horarioIda, 'origem': origemIda},
      "volta": {'horario': horarioVolta, 'origem': origemVolta}
    };

    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("viagens")
        .push()
        .set(viagem)
        .then((value) => print("Viagem cadastrada com sucesso!"))
        .catchError((error) => print("Ocorreu um erro $error"));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PageHome(),
        ),
        (route) => false);
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
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 10),
                  child: TextField(
                    controller: _controllerNome,
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

                const SizedBox(
                  height: 40.0,
                ),

                TextField(
                  controller: _controllerNumPassageiros,
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
                          child: TextField(
                            controller: _controllerHorarioIda,
                            autocorrect: false,
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [maskTime],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              //Style Hint
                              hintStyle: const TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.4),
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
                          child: TextField(
                            controller: _controllerHorarioVolta,
                            autocorrect: false,
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [maskTime],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              //Style Hint
                              hintStyle: const TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.4),
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
                          child: TextField(
                            controller: _controllerOrigemIda,
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              //Style Hint
                              hintStyle: const TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.4),
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
                          child: TextField(
                            controller: _controllerOrigemVolta,
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              //Style Hint
                              hintStyle: const TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.4),
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
                      primary: Color.fromRGBO(51, 101, 229, 1),
                      onPrimary: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {
                      _criaViagem(
                          _controllerNome.text,
                          _controllerNumPassageiros.text,
                          _controllerHorarioIda.text,
                          _controllerOrigemIda.text,
                          _controllerHorarioVolta.text,
                          _controllerOrigemVolta.text);
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

                //mensagem de erro
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
            ),
          ),
        ),
      ),
    );
  }
}
