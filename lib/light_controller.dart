import 'package:flutter/foundation.dart';

class LightController with ChangeNotifier {
  bool _isLightOn = false;

  bool get isLightOn => _isLightOn;

  void toggleLight() {
    _isLightOn = !_isLightOn;
    notifyListeners();
  }
}
