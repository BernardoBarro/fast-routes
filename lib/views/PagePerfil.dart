import 'dart:io';
import 'dart:ui';
import 'package:fast_routes/models/Customer.dart';
import 'package:fast_routes/providers/UserProvider.dart';
import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:fast_routes/views/PageConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'PagesPassengers/PageHomePassenger.dart';


class PagePerfil extends StatefulWidget {
  const PagePerfil({Key? key}) : super(key: key);

  @override
  State<PagePerfil> createState() => _PagePerfilState();
}

class _PagePerfilState extends State<PagePerfil> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  final double circleRadius = 150.0;
  final double circleBorderWidth = 50.0;

  String changeName = 'Matheus Grigoleto';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageConfig()));
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
        height: 120,
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
    children: 
          [
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
                                    borderRadius: BorderRadius.circular(100)),
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
            child: Text(changeName, style: TextStyle(color: Colors.white, fontSize: 18),),
          )
        ],
        
       ),
     ),
    ],
  ),
  ),
  SizedBox(height: 20,),
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
                      onPressed: () {},
                      child: Text(
                        "Pré - View",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                    )),
  ],),
  SizedBox(height: 20,),
   
  Container(
    height: 380,
    width: double.infinity,
     child: Card(
       color: Color.fromRGBO(69, 69, 85, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          child: Column(           
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                 padding: const EdgeInsets.only(top: 15.0, left: 15),
                 child: Text(
                  'Viagens',
                  style: TextStyle(fontSize: 18, color: Colors.white),
              ),
               ),   
                Padding(
                 padding: const EdgeInsets.only(left: 15.0, top: 25),
                 child: Text(
                    'Viagem 1',
                    style: TextStyle(fontSize: 18, color: Colors.white),
              ),
               ),     
              
            Row(mainAxisAlignment: MainAxisAlignment.end,     
              children: [InkWell(child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(Icons.add, color: Colors.white,),
              ))],)
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
}
