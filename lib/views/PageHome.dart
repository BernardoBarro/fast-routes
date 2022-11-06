import 'package:fast_routes/providers/AddressProvider.dart';
import 'package:fast_routes/providers/TravelProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fast_routes/views/PageMaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'PageViagens.dart';
import 'PagePerfil.dart';
import 'PagesPassengers/PageHomePassenger.dart';

class PageHome extends StatefulWidget {
  final String? chave;

  const PageHome({Key? key, this.chave}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 1;

  // final List<Widget> _telas = [
  //   ChangeNotifierProvider(
  //     create: (_) => UserProvider(),
  //     child: PagePerfil(),
  //   ),
  //   ChangeNotifierProvider(
  //     create: (_) => AddressProvider(),
  //     child: PageMaps(chave: widget.chave),
  //   ),
  //   ChangeNotifierProvider(
  //     create: (_) => TravelProvider(),
  //     child: PageViagens(),
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      body: [
        ChangeNotifierProvider(
          create: (_) => TravelProvider(),
          child: PagePerfil(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
          child: PageMaps(chave: widget.chave),
        ),
        ChangeNotifierProvider(
          create: (_) => TravelProvider(),
          child: PageViagens(),
        ),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromRGBO(69, 69, 85, 1),
        unselectedItemColor: Color.fromARGB(57, 255, 255, 255),
        selectedItemColor: Color.fromRGBO(255, 255, 255, 1),
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_sharp,
            ),
            label: 'Viagens',
          ),
        ],
      ),
    );
  }

  void _performingSingleFetch() {
    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("isMotorista")
        .get()
        .then((snapshot) {
      bool isMotorista = (snapshot.value as dynamic);
      if (!isMotorista) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PageHomePassenger()));
      }
    });
  }
}
