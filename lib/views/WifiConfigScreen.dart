import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallbox_app/repository/WallboxRepository.dart';
import 'package:wifi_flutter/wifi_flutter.dart';

class WifiConfigScreen extends StatefulWidget {
  @override
  _WifiConfigScreenState createState() => _WifiConfigScreenState();
}

class _WifiConfigScreenState extends State<WifiConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  List<String> _wifiNetworks = [];
  String? _selectedWifi;
  WallboxRepository repository = WallboxRepository.instance();

  @override
  void initState() {
    super.initState();
    _getWifiNetworks();
  }

  Future<void> _getWifiNetworks() async {
    var list = await repository.avaliableNetworks();

    setState(() {
      for (var element in list) {
        print(element);
        _wifiNetworks.add(element);
      }
    });
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
              DropdownButtonFormField<String>(
                items: _wifiNetworks.map((String network) {
                  return DropdownMenuItem<String>(
                    value: network,
                    child: Text(network),
                  );
                }).toList(),
                onChanged: (String? selectedWifi) {
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
                      repository
                          .setWifi(
                              _selectedWifi!, _passwordController.value.text)
                          .then((result) {
                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Configurações salvas com sucesso!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Não foi possivel salvar a configuração.')),
                          );
                        }
                      });
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
