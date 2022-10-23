// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:fast_routes/models/Customer.dart';
import 'package:fast_routes/providers/UserProvider.dart';
import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class PagePerfil extends StatefulWidget {
  const PagePerfil({Key? key}) : super(key: key);

  @override
  State<PagePerfil> createState() => _PagePerfilState();
}

class _PagePerfilState extends State<PagePerfil> {
  var maskPhone = MaskTextInputFormatter(mask: '(##) #####-####');
  var maskCPF = MaskTextInputFormatter(mask: '###.###.###-##');
  bool fieldOcult = false;

  String textChange = 'Editar Perfil';
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

  final ChangeName = TextEditingController(text: 'Matheus Grigoleto');

  _hiddenFields() {
    setState(() {
      if (fieldOcult == false) {
        textChange = 'Salvar';
        fieldOcult = true;
      } else if (fieldOcult == true) {
        textChange = 'Editar Perfil';
        fieldOcult = false;
      }
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
          // child: SingleChildScrollView(
          child: Column(
            children: [
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
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.black12,
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
              ),
              Consumer<UserProvider>(builder: (context, model, child) {
                Customer user = model.user;
                String _calcularIdade(){
                  List<String> campos = user.birthDate.split('/');
                  int dia = int.parse(campos[0]);
                  int mes = int.parse(campos[1]);
                  int ano = int.parse(campos[2]);
                  DateTime nascimento = DateTime(ano,mes,dia);
                  DateTime hoje = DateTime.now();

                  int idade = hoje.year - nascimento.year;
                  if (hoje.month<nascimento.month)
                    idade--;
                  else if (hoje.month==nascimento.month){
                    if (hoje.day<nascimento.day)
                      idade--;
                  }
                  print(idade);
                  return "$idade";
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          enabled: fieldOcult,
                          controller: ChangeName,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 25,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //E-MAIL
                        TextFormField(
                          enabled: fieldOcult,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            //Style Label
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style Hint
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style borders
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),

                            //Labels Nome
                            hintText: user.email,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),

                        //TEXT TELEFONE
                        TextFormField(
                          enabled: fieldOcult,
                          inputFormatters: [maskPhone],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            //Style Label
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style Hint
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style borders
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),

                            //Labels Nome
                            hintText: user.phone,
                          ),
                        ),

                        const SizedBox(
                          height: 10.0,
                        ),
                        //TEXT CPF
                        TextFormField(
                          enabled: fieldOcult,
                          inputFormatters: [maskCPF],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            //Style Label
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style Hint
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style borders
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),

                            //Labels Nome
                            hintText: user.cpf,
                          ),
                        ),

                        const SizedBox(
                          height: 10.0,
                        ),
                        //E-MAIL
                        TextFormField(
                          enabled: fieldOcult,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            //Style Label
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style Hint
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),

                            //Style borders
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),

                            //Labels Nome
                            hintText: _calcularIdade(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        //BUTTON
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SizedBox(
                              width: 150,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromRGBO(51, 101, 229, 1),
                                  onPrimary: Colors.white,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hiddenFields();
                                  });
                                },
                                child: const Text(
                                  "EDITAR PERFIL",
                                  style: TextStyle(
                                    fontFamily: 'InriaSans',
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
