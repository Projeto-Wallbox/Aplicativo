import 'package:flutter/material.dart';
import 'package:wallbox_app/views/CarListScreen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String deviceIP;

  const HomePage({super.key, required this.deviceIP});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLightOn = false;
  int _currentIndex = -1;

  void _toggle() {
    http.post(Uri.parse('http://${widget.deviceIP}'), body: {
      'type': 'toggleRequest',
    }).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _isLightOn = !_isLightOn;
        });
      }
    }).catchError((error) {
      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Conexão foi perdida!')));
    }).whenComplete(() {});
  }

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return CarListScreen();
      case -1:
      default:
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The wallbox is turned ${_isLightOn ? 'On' : 'Off'}'),
            const SizedBox(height: 20),
            Switch(
              value: _isLightOn,
              onChanged: (value) {
                _toggle();
              },
            ),
          ],
        )); // homepage
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
            ListTile(
              title: const Text('Lista de Carros'),
              onTap: () {
                Navigator.pop(context); // Fechar o drawer
                _changeScreen(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
