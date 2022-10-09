import 'package:fast_routes/views/PageHome.dart';
import 'package:fast_routes/views/PageMap.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

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

  _criaViagem(String nome, String numPassageiros, String horarioIda,
      String origemIda, String horarioVolta, String origemVolta) {
    FirebaseDatabase db = FirebaseDatabase.instance;
    User? usuarioLogado = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> viagem = {
      'nome': nome,
      'numPassageiros': numPassageiros,
    };

    Map<String, dynamic> ida = {'horario': horarioIda, 'origem': origemIda};

    Map<String, dynamic> volta = {
      'horario': horarioVolta,
      'origem': origemVolta
    };

    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("viagens")
        .child(nome)
        .set(viagem)
        .then((value) => {
              db
                  .ref("usuarios")
                  .child(usuarioLogado!.uid)
                  .child("viagens")
                  .child(nome)
                  .child("ida")
                  .set(ida)
                  .then((value) => {
                        db
                            .ref("usuarios")
                            .child(usuarioLogado!.uid)
                            .child("viagens")
                            .child(nome)
                            .child("volta")
                            .set(volta)
                      })
            });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PageHome()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 10),
                    child: TextField(
                      controller: _controllerNome,
                      //autofocus: true,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(fontSize: 16),
                      autocorrect: false,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Insira o nome da viagem",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  //cpf text
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerNumPassageiros,
                      //autofocus: true,
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Insira número de passageiros",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  //senha Text
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerHorarioIda,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Insira horario de ida",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  //senha Text
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerOrigemIda,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Insira origem de ida",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerHorarioVolta,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Insira horario de volta",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerOrigemVolta,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Insira origem de volta",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          _criaViagem(
                              _controllerNome.text,
                              _controllerNumPassageiros.text,
                              _controllerHorarioIda.text,
                              _controllerOrigemIda.text,
                              _controllerHorarioVolta.text,
                              _controllerOrigemVolta.text);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            elevation: 0,
                            padding: EdgeInsets.all(12),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20))),
                        child: Text(
                          "Criar Conta",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )),
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
      ),
    );
  }
}
