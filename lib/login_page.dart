import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallbox_app/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:wallbox_app/repository/WallboxRepository.dart';
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

    WallboxRepository wallboxRepository =
        WallboxRepository(ipAdd: widget.deviceIP);
    wallboxRepository.login(username, password).then((status) {
      if (status) {
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
      print(error);
      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao estabelecer uma conexão!')));
    });
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
