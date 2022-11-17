import 'package:fast_routes/providers/AddressProvider.dart';
import 'package:fast_routes/providers/PassengersAddressProvider.dart';
import 'package:fast_routes/providers/UserProvider.dart';
import 'package:fast_routes/views/PageMaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:fast_routes/views/PagesPassengers/PagePerfilPassenger.dart';
import 'package:fast_routes/views/PagesPassengers/PageMyAddress.dart';
import '../../providers/TravelProvider.dart';

class PageHomePassenger extends StatefulWidget {
  const PageHomePassenger({Key? key}) : super(key: key);

  @override
  State<PageHomePassenger> createState() => _PageHomePassengerState();
}

class _PageHomePassengerState extends State<PageHomePassenger> {
  int _selectedIndex = 1;
  final List<Widget> _telas = [
    ChangeNotifierProvider(
      create: (_) => PassengersAddressProvider(),
      child: PagePerfilPassenger(),
    ),
    ChangeNotifierProvider(
      create: (_) => AddressProvider(),
      child: PageMaps(),
    ),
    ChangeNotifierProvider(
      create: (_) => TravelProvider(),
      child: PageMyAddress(),
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
        backgroundColor: const Color.fromARGB(223, 69, 69, 85),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_outlined,
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
            label: 'Minhas Viagens',
          ),
        ],
      ),
    );
  }
}
