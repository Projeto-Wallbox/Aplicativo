import 'dart:async';
import 'package:flutter/material.dart';
import 'package:network_discovery/network_discovery.dart';
import 'login_page.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  const DeviceDiscoveryPage({super.key});

  @override
  _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  final List<String> devices = [];
  bool searching = false;

  Future<String?> getSubnet() async {
    final String deviceIP = await NetworkDiscovery.discoverDeviceIpAddress();

    if (deviceIP.isNotEmpty) {
      return deviceIP.substring(0, deviceIP.lastIndexOf('.'));
    } else {
      return null;
    }
  }

  Future<void> discoverDevices() async {
    if (searching) return;
    searching = true;
    setState(() {
      devices.clear();
    });
    final String? subnet = await getSubnet();
    if (subnet != null) {
      final stream = NetworkDiscovery.discoverAllPingableDevices(subnet);
      final List<String> localDevices = [];
      stream.listen((HostActive host) {
        if (host.isActive) {
          localDevices.add(host.ip);
          setState(() {
            devices.clear();
            devices.addAll(localDevices);
          });
        }
      }).onDone(() => searching = false);
    }
  }

  @override
  void initState() {
    super.initState();
    discoverDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Device Discovery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                discoverDevices();
              },
            ),
          ],
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dois quadrados por linha
            crossAxisSpacing:
                10.0, // Espaçamento entre os quadrados na horizontal
            mainAxisSpacing: 10.0, // Espaçamento entre os quadrados na vertical
            childAspectRatio: 1.0, // Proporção da largura para a altura
          ),
          itemCount: devices.length + 1, // Adiciona 1 para o quadrado extra
          itemBuilder: (context, index) {
            if (index == devices.length) {
              // Se for o último item, retorna o quadrado extra com o símbolo de adição
              return GestureDetector(
                onTap: () {
                  // Faça o que desejar ao tocar no quadrado extra
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 40.0,
                    color: Colors.blue,
                  ),
                ),
              );
            } else {
              // Se não for o último item, retorna o quadrado do dispositivo
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(deviceIP: devices[index]),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                      devices[index],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
