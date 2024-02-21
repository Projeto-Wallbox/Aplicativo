import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_flutter/wifi_flutter.dart';

class WifiConfigScreen extends StatefulWidget {
  @override
  _WifiConfigScreenState createState() => _WifiConfigScreenState();
}

class _WifiConfigScreenState extends State<WifiConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  List<WifiNetwork> _wifiNetworks = [];
  WifiNetwork? _selectedWifi;

  @override
  void initState() {
    super.initState();
    _getWifiNetworks();
  }

  Future<void> _getWifiNetworks() async {
    _wifiNetworks.add(new WifiNetwork('teste', 0, true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<WifiNetwork>(
                items: _wifiNetworks.map((WifiNetwork network) {
                  return DropdownMenuItem<WifiNetwork>(
                    value: network,
                    child: Text(network.ssid),
                  );
                }).toList(),
                onChanged: (WifiNetwork? selectedWifi) {
                  if (selectedWifi != null) {
                    setState(() {
                      _selectedWifi = selectedWifi;
                    });
                  }
                },
                value: _selectedWifi,
                decoration:
                    const InputDecoration(labelText: 'Selecione a rede Wi-Fi'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma rede Wi-Fi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a senha';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Salvar as informações (ainda não implementado)
                      // Você pode acessar os valores digitados pelo usuário através de _selectedWifi e _passwordController.text
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Configurações salvas com sucesso!')),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
