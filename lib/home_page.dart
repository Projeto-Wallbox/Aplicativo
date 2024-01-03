import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  final String deviceIP;

  const HomePage({super.key, required this.deviceIP});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebSocketChannel _channel;
  bool _isLightOn = false;

  void startChannel(context) async {
    final wsUrl = Uri.parse('ws://${widget.deviceIP}');
    //final wsUrl = Uri.parse('ws://localhost:8765');
    _channel = WebSocketChannel.connect(wsUrl);
    _channel.ready.then((value) {
      _channel.stream.listen((message) {
        final data = jsonDecode(message);
        if (data['type'] == "toggleResponse" && data['status'] == "Ok") {
          setState(() {
            _isLightOn = !_isLightOn;
          });
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
    _channel.sink.close();
    super.dispose();
  }

  void _toggle() {
    // Criar um mapa com dados do usuário
    Map<String, dynamic> userData = {
      'type': 'toggleRequest',
    };

    // Converter mapa para JSON
    String jsonUserData = jsonEncode(userData);

    // Enviar JSON via WebSocket
    _channel.sink.add(jsonUserData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
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
      )),
    );
  }
}
