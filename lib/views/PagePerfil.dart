import 'dart:io';
import 'dart:ui';
import 'package:fast_routes/models/Customer.dart';
import 'package:fast_routes/providers/UserProvider.dart';
import 'package:fast_routes/views/InviteSideBar.dart';
import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/PagesPassengers/InviteSideBarPassageiro.dart';
import 'package:fast_routes/views/PagesPassengers/PageHomePassenger.dart';
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
      appBar: AppBar(
      centerTitle: true,
      toolbarHeight: 65,
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(223, 69, 69, 85),
      elevation: 2,
      title: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text("Meu Perfil",),
      ),),
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
          padding: const EdgeInsets.only(top: 15, right: 16, left: 16),
           child: SingleChildScrollView(
          child: Column(
            children: [
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
                      color: Colors.white,
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
                height: 15,
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
                      width: 150,
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
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                         Navigator.push(context,
            MaterialPageRoute(builder: (context) => PageHomePassenger()));
                        },
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
              SingleChildScrollView(
              child: Container(
                height: 400,
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
                    
                    
                    children: [       
                      Consumer<TravelProvider>(
                          builder: (context, model, child) {
                        return Expanded(
                            child: ListView(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                                child: Text('Minhas Viagens', textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                          ...model.travels.map(
                            (travel) => Padding(
                              padding: const EdgeInsets.only(left: 15.0,right: 15),
                              child: Card(                            
                                   color: Color.fromARGB(227, 108, 108, 126),
                                   elevation: 3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                           left: 15.0),
                                      child: ListTile(
                                        title: Text(travel.nome,style: TextStyle(color: Colors.white),),
                                        subtitle: Text(travel.weekDays,style: TextStyle(color:Color.fromARGB(174, 255, 255, 255))),
                                      ))),
                            ),
                                    
                          )
                        ]));
                      }),
                       
                      Container(
                        height: 45,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            child: Padding(
                            padding: const EdgeInsets.only(right: 20.0, bottom: 12.0),
                            child: Icon(Icons.add, color: Colors.blue,),
                          ),       
                          onTap: (){},         
                          ),
                           ),
                      ),              
                    ],          
                  ),          
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

  void _performingSingleFetch() {
    db.ref("usuarios").child(usuarioLogado!.uid).child("nome").get().then((snapshot) {
      setState(() {
        changeName = (snapshot.value as dynamic);
      });
    });
  }
}
