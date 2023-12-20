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
