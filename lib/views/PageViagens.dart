import 'package:fast_routes/models/Travel.dart';
import 'package:fast_routes/providers/TravelProvider.dart';
import 'package:fast_routes/views/ListPassengers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/TravelPassagerProvider.dart';
import 'PageCreateTravel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageViagens extends StatefulWidget {
  const PageViagens({Key? key}) : super(key: key);

  @override
  State<PageViagens> createState() => _PageViagensState();
}

class _PageViagensState extends State<PageViagens> {
  _pageCreateTravel() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PageCreateTravel()));
    });
  }

  @override
  Widget build(BuildContext context) {
    User? usuarioLogado = FirebaseAuth.instance.currentUser;
    final db = FirebaseDatabase.instance.ref("usuarios");
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      toolbarHeight: 65,
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(223, 69, 69, 85),
      elevation: 2,
      title: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text("Minhas Viagens",),
      ),),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: Column(
            children: [
              Consumer<TravelProvider>(builder: (context, model, child) {
                return Expanded(
                    child: ListView(
                  children: [
                    ...model.travels.map((travel) => Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                            create: (_) =>
                                                TravelPassagerProvider(
                                                    travel.key),
                                            child: ListPassengers(travel.key),
                                          )));
                            },
                            child: SizedBox(
                              width: 350,
                              height: 100,
                              child: Center(
                                child: ListTile(
                                  trailing: Builder(
                                    builder: (BuildContext context) {
                                      return IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.white,),
                                        onPressed: () {
                                          showAlertDialog(context, travel, db,
                                              usuarioLogado);
                                        },
                                      );
                                    },
                                  ),
                                  textColor: Color.fromRGBO(255, 255, 255, 1),
                                  title: Text(
                                    travel.nome,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    travel.weekDays,
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                        color:
                                            Color.fromARGB(174, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ));
              })
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: _pageCreateTravel,
            child: Icon(
              Icons.add,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, Travel travel,
      DatabaseReference db, User? usuarioLogado) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(223, 69, 69, 85),
            title: const Text("Confirmação!!", style: TextStyle(color: Colors.white)),
            content: Text("Você tem certeza que deseja excluir a viagem: " +
                travel.nome +
                "?",style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Não",style: TextStyle(color: Colors.white))),
              TextButton(
                  onPressed: () {
                    removeTravel(db, usuarioLogado, travel);
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Sim",style: TextStyle(color: Colors.white))),
            ],
          );
        });
  }

  void removeTravel(DatabaseReference db, User? usuarioLogado, Travel travel) {
    db.child(usuarioLogado!.uid).child('viagens').child(travel.key).remove();
  }
}
