import 'package:flutter/material.dart';
import 'package:wallbox_app/views/CarListScreen.dart';
import 'package:http/http.dart' as http;
import 'package:wallbox_app/views/ChargerConfigurationScreen.dart';
import 'package:wallbox_app/views/CharginReportScreen.dart';
import 'package:wallbox_app/views/ChargingScreen.dart';
import 'package:wallbox_app/views/FAQScreen.dart';
import 'package:wallbox_app/views/WifiConfigScreen.dart';

class HomePage extends StatefulWidget {
  final String deviceIP;

  const HomePage({super.key, required this.deviceIP});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = -1;

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return CarListScreen();
      case 1:
        return WifiConfigScreen();
      case 2:
        return ChargingReportScreen();
      case 3:
        return ChargerConfigurationScreen();
      case 4:
        return ChargingScreen();
      case 5:
        return FAQScreen();
      case -1:
      default:
        return ChargingScreen();
      // return Center(
      //     child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text('The wallbox is turned ${_isLightOn ? 'On' : 'Off'}'),
      //     const SizedBox(height: 20),
      //     Switch(
      //       value: _isLightOn,
      //       onChanged: (value) {
      //         _toggle();
      //       },
      //     ),
      //   ],
      // )); // homepage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intral App'),
      ),
      body: _getCurrentScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(-1);
              },
            ),
            // ListTile(
            //   title: const Text('Recarga'),
            //   onTap: () {
            //     Navigator.pop(context); // Fechar o drawer
            //     _changeScreen(4);
            //   },
            // ),
            ListTile(
              title: const Text('Lista de Carros'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(0);
              },
            ),
            ListTile(
              title: const Text('Relatorio'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(2);
              },
            ),
            ListTile(
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(5);
              },
            ),
            ListTile(
              title: const Text('Configuração WIFI'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(1);
              },
            ),
            ListTile(
              title: const Text('Configuração Avançada'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
