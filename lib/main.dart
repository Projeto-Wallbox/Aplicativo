import 'package:flutter/material.dart';
import 'device_discovery_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Light App',
      home: const DeviceDiscoveryPage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        secondaryHeaderColor: Colors.orange,
        fontFamily: 'Roboto',
      ),
    );
  }
}
