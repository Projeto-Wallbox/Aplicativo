import 'package:flutter/material.dart';

class ChargingReportScreen extends StatelessWidget {
  // Dados fictícios do carregamento do carro elétrico (potência ao longo do tempo)
  final List<Map<String, dynamic>> chargingData = [
    {'tempo': '0 min', 'tensao': '220V', 'corrente': '10A'},
    {'tempo': '30 min', 'tensao': '220V', 'corrente': '12A'},
    {'tempo': '60 min', 'tensao': '220V', 'corrente': '14A'},
    {'tempo': '90 min', 'tensao': '220V', 'corrente': '15A'},
    {'tempo': '120 min', 'tensao': '220V', 'corrente': '16A'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Tempo')),
              DataColumn(label: Text('Tensão')),
              DataColumn(label: Text('Corrente')),
            ],
            rows: chargingData.map((data) {
              return DataRow(cells: [
                DataCell(Text(data['tempo'])),
                DataCell(Text(data['tensao'])),
                DataCell(Text(data['corrente'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
