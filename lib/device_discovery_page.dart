import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dart_ping/dart_ping.dart';
import 'login_page.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  const DeviceDiscoveryPage({super.key});

  @override
  _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  final List<String> devices = [];

  Future<void> discoverDevices() async {
    final List<String> localDevices = [];

    const String subnet = '192.168.0'; // Update with your subnet

    for (int i = 1; i <= 255; i++) {
      final String host = '$subnet.$i';
      final Ping ping = Ping(host, count: 1);
      ping.stream.listen((event) {
        final result = event.response;
        // if (result.) {
        //   localDevices.add(host);
        //   setState(() {
        //     devices.clear();
        //     devices.addAll(localDevices);
        //   });
        // }
        print(result);
      });
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
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(deviceIP: devices[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
