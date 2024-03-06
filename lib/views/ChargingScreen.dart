import 'package:flutter/material.dart';
import 'package:wallbox_app/database.dart';

class ChargingScreen extends StatefulWidget {
  @override
  _ChargingScreenState createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<ChargingScreen> {
  List<Car> _carsList = List.empty();
  Car? selectedCar; // Carro selecionado por padrão

  final double currentPower = 100; // Potência consumida atual (em watts)
  final int chargingTime = 12; // Tempo de carga até o momento (em minutos)
  final double totalConsumption =
      64; // Consumo total até o momento (em watts/hora)

  void loadCars() async {
    final database = AppDatabase.instance();
    final carsList = await database.select(database.cars).get();
    setState(() {
      _carsList = carsList;
    });
  }

  @override
  void initState() {
    loadCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<Car>(
                  value: selectedCar,
                  onChanged: (Car? newValue) {
                    setState(() {
                      selectedCar = newValue;
                    });
                  },
                  items: _carsList.map<DropdownMenuItem<Car>>((Car value) {
                    return DropdownMenuItem<Car>(
                      value: value,
                      child: Text(value.name ?? 'Selecione um carro'),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: currentPower != 0
                        ? const ColorFilter.mode(Colors.white, BlendMode.darken)
                        : const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                    child: Image.asset(
                      'assets/car.png', // Coloque o caminho da imagem do veículo
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Potência Consumida Atual:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${currentPower.toStringAsFixed(2)} W',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tempo de Carga Até o Momento:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$chargingTime minutos',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Consumo Total Até o Momento:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${totalConsumption.toStringAsFixed(2)} W/h',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
