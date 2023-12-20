import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'light_controller.dart';
import 'device_discovery_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LightController(),
      child: MaterialApp(
        title: 'Flutter Light App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DeviceDiscoveryPage(),
      ),
    );
  }
}
