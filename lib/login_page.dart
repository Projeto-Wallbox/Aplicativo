import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallbox_app/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:wallbox_app/services/UserSessionService.dart';

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

  final UserSessionService userService = UserSessionService.instance();

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
    if (widget.deviceIP.isEmpty) {
      return;
    }
    http.get(Uri.parse('http://${widget.deviceIP}/users/self'), headers: {
      HttpHeaders.authorizationHeader:
          'Basic ${base64Encode(utf8.encode('$username:$password'))}'
    }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        userService.setUser(username);
        userService.setPassword(password);
        userService.setKey('ip', widget.deviceIP);
        userService.setKey('userId', data.id.toString());
        userService.setKey('permission', data.permission);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(deviceIP: widget.deviceIP),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Usuário ou senha inválidos';
        });
      }
    }).catchError((error) {
      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao estabelecer uma conexão!')));
    }).whenComplete(() {});
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
