import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallbox_app/home_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LoginPage extends StatefulWidget {
  final String deviceIP;

  const LoginPage({super.key, required this.deviceIP});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  late WebSocketChannel _channel;

  void startChannel(context) async {
    final wsUrl = Uri.parse('ws://${widget.deviceIP}');
    //final wsUrl = Uri.parse('ws://localhost:8765');
    _channel = WebSocketChannel.connect(wsUrl);
    _channel.ready.then((value) {
      _channel.stream.listen((message) {
        final data = jsonDecode(message);
        print(data);
        if (data['type'] == "userAuthResponse" && data['status'] == "Ok") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(deviceIP: widget.deviceIP),
            ),
          );
          print('Logado');
        } else {
          setState(() {
            _errorMessage = 'Usuário ou senha inválidos';
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

  void _login(BuildContext context) {
    // Lógica de login aqui (pode ser implementada posteriormente)
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'test' && password == 'test') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(deviceIP: 'test'),
        ),
      );
      return;
    }
    // Criar um mapa com dados do usuário
    Map<String, dynamic> userData = {
      'type': 'authenticateRequest',
      'login': username,
      'password': password,
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
        title: Text('Login: ${widget.deviceIP}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logo.png', // Substitua pelo caminho da sua imagem do logo
                height: 100.0,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0),
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
