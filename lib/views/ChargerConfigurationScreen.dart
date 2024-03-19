import 'package:flutter/material.dart';

class ChargerConfigurationScreen extends StatefulWidget {
  @override
  _ChargerConfigurationScreenState createState() =>
      _ChargerConfigurationScreenState();
}

class _ChargerConfigurationScreenState
    extends State<ChargerConfigurationScreen> {
  TextEditingController _maxCurrentController = TextEditingController();
  TextEditingController _masterPasswordController = TextEditingController();
  TextEditingController _voltageController = TextEditingController();
  TextEditingController _overcurrentThresholdController =
      TextEditingController();
  TextEditingController _undercurrentThresholdController =
      TextEditingController();
  TextEditingController _chargingTimeLimitController = TextEditingController();
  TextEditingController _connectionTimeoutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configurações Avançadas',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _maxCurrentController,
                decoration: InputDecoration(
                  labelText: 'Corrente Máxima (A)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _masterPasswordController,
                decoration: InputDecoration(
                  labelText: 'Senha Mestre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _voltageController,
                decoration: InputDecoration(
                  labelText: 'Voltagem da Rede (V)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _overcurrentThresholdController,
                decoration: InputDecoration(
                  labelText: 'Limite de Sobrecorrente (A)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _undercurrentThresholdController,
                decoration: InputDecoration(
                  labelText: 'Limite de Subcorrente (A)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _chargingTimeLimitController,
                decoration: InputDecoration(
                  labelText: 'Limite de Tempo de Carregamento (min)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _connectionTimeoutController,
                decoration: InputDecoration(
                  labelText: 'Tempo Limite de Conexão (min)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica para salvar as configurações
                },
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
