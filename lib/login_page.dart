import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'light_controller.dart';

class LoginPage extends StatelessWidget {
  final String deviceIP;

  LoginPage({required this.deviceIP});

  // Your login logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Device: $deviceIP'),
            // Other login UI components
            ElevatedButton(
              onPressed: () {
                // Perform login logic here
                // For simplicity, just navigate to home page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
