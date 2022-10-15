import 'package:fast_routes/models/TravelModel.dart';
import 'package:fast_routes/views/Maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'PageViagens.dart';
import 'PagePerfil.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _selectedIndex = 1;
  final List<Widget> _telas = [
    PagePerfil(),
    Maps(),
    ChangeNotifierProvider(
      create: (_) => TravelModel(),
      child: PageViagens(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_selectedIndex],
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
}
