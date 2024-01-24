import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallbox_app/views/CarListScreen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  final String deviceIP;

  const HomePage({super.key, required this.deviceIP});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebSocketChannel? _channel;
  bool _isLightOn = false;
  int _currentIndex = -1;

  void startChannel(context) async {
    if (widget.deviceIP == 'test') return;
    final wsUrl = Uri.parse('ws://${widget.deviceIP}');
    //final wsUrl = Uri.parse('ws://localhost:8765');
    WebSocketChannel channel = WebSocketChannel.connect(wsUrl);
    _channel = channel;
    channel.ready.then((value) {
      channel.stream.listen((message) {
        final data = jsonDecode(message);
        if (data['type'] == "toggleResponse" && data['status'] == "Ok") {
          // setState(() {
          //   _isLightOn = !_isLightOn;
          // });
        }
      }, onError: (error) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Conexão foi perdid!')));
      });
    }).onError((error, stackTrace) {
      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao estabelecer uma conexão!')));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => startChannel(context));
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  void _toggle() {
    // Criar um mapa com dados do usuário
    Map<String, dynamic> userData = {
      'type': 'toggleRequest',
    };
    setState(() {
      _isLightOn = !_isLightOn;
    });
    // Converter mapa para JSON
    String jsonUserData = jsonEncode(userData);

    // Enviar JSON via WebSocket
    _channel?.sink.add(jsonUserData);
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
