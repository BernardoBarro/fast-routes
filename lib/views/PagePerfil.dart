import 'dart:io';
import 'dart:ui';
import 'package:fast_routes/models/Customer.dart';
import 'package:fast_routes/providers/UserProvider.dart';
import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/InviteSideBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import '../providers/InviteProvider.dart';
import '../providers/TravelProvider.dart';

class PagePerfil extends StatefulWidget {
  const PagePerfil({Key? key}) : super(key: key);

  @override
  State<PagePerfil> createState() => _PagePerfilState();
}

class _PagePerfilState extends State<PagePerfil> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  final double circleRadius = 120.0;
  final double circleBorderWidth = 50.0;

  String changeName = 'Loading...';

  _logout() async {
    FirebaseAuth.instance.signOut();
    setState(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginandRegister()),
          (route) => false);
    });
  }

  late File _image = File('/images/logo.png');
  bool imageOK = false;

  //instancia do objeto picker utilizado para acessar a camera e album do dispositivo
  final ImagePicker _picker = ImagePicker();

  //Função resposavel por capturar a imagem e salvar o caminho dela
  //para posteriormente ser recuperada e mostrada
  _imgFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      _image = File(pickedFile!.path);
      imageOK = true;
    });
  }

  //mesma coisa só que com o album
  _imgFromLibrary() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30);

    setState(() {
      _image = File(pickedFile!.path);
      imageOK = true;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_album),
                  title: const Text('Album'),
                  onTap: () {
                    _imgFromLibrary();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    _performingSingleFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: ChangeNotifierProvider(
        create: (_) => InviteProvider(),
        child: InviteSideBar(),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(69, 69, 85, 1),
          padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: FlatButton.icon(
                    onPressed: () {
                      _globalKey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    label: Text(''),
                    padding: EdgeInsets.only(right: 40),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton.icon(
                    onPressed: () {
                      _logout();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Color.fromRGBO(51, 101, 229, 1),
                    ),
                    label: const Text(
                      "Deslogar",
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    ),
                    padding: EdgeInsets.only(left: 0),
                  ),
                ),
              ]),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: circleRadius / 10.0),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          border: Border(
                            left: BorderSide(
                              color: Colors.green,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: circleRadius,
                            height: circleRadius,
                            child: imageOK != (false)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                        color: Colors.grey,
                                        height: 300,
                                        width: 300,
                                        child: Image.file(_image)))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    width: 300,
                                    height: 300,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              changeName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 80,
                      width: 180,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          "Iniciar Viagem",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'InriaSans',
                          ),
                        ),
                      )),
                  SizedBox(
                      height: 80,
                      width: 180,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          "Pré - View",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'InriaSans',
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 440,
                width: double.infinity,
                child: Card(
                  color: const Color.fromRGBO(69, 69, 85, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<TravelProvider>(
                          builder: (context, model, child) {
                        return Expanded(
                            child: ListView(children: [
                          ...model.travels.map(
                            (travel) => Card(
                                color: Color.fromRGBO(69, 69, 85, 0.8),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, left: 15.0),
                                    child: ListTile(
                                      title: Text(travel.nome),
                                      subtitle: Text(travel.weekDays),
                                    ))),
                          )
                        ]));
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performingSingleFetch() {
    db.ref("usuarios").child(usuarioLogado!.uid).child("nome").get().then((snapshot) {
      setState(() {
        changeName = (snapshot.value as dynamic);
      });
    });
  }
}
