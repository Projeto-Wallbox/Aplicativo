import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'light_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Consumer<LightController>(
          builder: (context, lightController, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'The wallbox is turned ${lightController.isLightOn ? 'On' : 'Off'}'),
                SizedBox(height: 20),
                Switch(
                  value: lightController.isLightOn,
                  onChanged: (value) {
                    lightController.toggleLight();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
