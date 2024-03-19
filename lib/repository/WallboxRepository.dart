import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:wallbox_app/services/UserSessionService.dart';
import 'package:http/http.dart' as http;

class WallboxRepository {
  String ipAdd;
  late UserSessionService service;

  static WallboxRepository instance() {
    UserSessionService service = UserSessionService.instance();
    return WallboxRepository(ipAdd: service.getKey('ip') ?? '');
  }

  WallboxRepository({required this.ipAdd}) {
    service = UserSessionService.instance();
  }

  Future<Map<String, String>> getCurrentMetetValue() async {
    if (ipAdd.isEmpty && await lightState()) {
      var rng = Random();

      var voltage = 218 + rng.nextDouble() * 3;
      var current = 19 + rng.nextDouble() * 1.5;

      return {
        'energy': 100.toString(),
        'power': (current * voltage).toString(),
        'current': current.toString(),
        'voltage': voltage.toString(),
      };
    } else if (ipAdd.isNotEmpty) {
      var response =
          await http.post(Uri.parse('http://${ipAdd}/networkConnect'),
              body: {
                'type': 'MeterValues',
              },
              headers: service.getHeader());

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var transaction = body.transactionId;
        for (var obj in body.meterValue) {
          var sample = obj.sampledValue;

          return {
            'energy': sample.energy,
            'power': sample.power,
            'current': sample.current,
            'voltage': sample.voltage,
          };
        }
      }
    }
    return {
      'energy': '0',
      'power': '0',
      'current': '0',
      'voltage': '0',
    };
  }

  Future<bool> setWifi(String ssid, String password) async {
    if (ipAdd.isEmpty) {
      return true;
    } else {
      var response =
          await http.post(Uri.parse('http://${ipAdd}/networkConnect'),
              body: {
                'ssid': ssid,
                'password': password,
                'timeout': 10,
              },
              headers: service.getHeader());
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return body.status == 'Ok';
      }
      return false;
    }
  }

  Future<List<String>> avaliableNetworks() async {
    List<String> list = [];
    if (ipAdd.isEmpty) {
      list.add('wifi a');
      list.add('wifi b');
    } else {
      int repeat = 10;
      while (repeat > 0) {
        var response = await http.get(
            Uri.parse('http://${ipAdd}/networkScan?timeout=5'),
            headers: service.getHeader());
        switch (response.statusCode) {
          case 202:
          case 102:
            break;
          case 200:
            repeat = 0;
            var body = jsonDecode(response.body);
            body.avaliableNetworks.map((element) {
              if (element.ssid != null) list.add(element.ssid);
            });
            break;
          default:
            repeat = 0;
            throw Exception('Failed to load networks');
        }
        if (repeat > 0) {
          sleep(const Duration(seconds: 1));
        }
      }
    }
    return list;
  }

  Future<bool> toggleState() async {
    if (ipAdd.isEmpty) {
      service.setKey('test_light_state', await lightState() ? 'false' : 'true');
      return true;
    } else {
      var response = await http.post(Uri.parse('http://${ipAdd}'),
          body: {
            'type': 'toggleRequest',
          },
          headers: service.getHeader());
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    }
  }

  Future<bool> lightState() async {
    if (ipAdd.isEmpty) {
      return (service.getKey('test_light_state') ?? 'false') == 'true';
    } else {
      return false;
    }
  }

  Future<bool> login(String user, String password) async {
    if (ipAdd.isNotEmpty) {
      var response =
          await http.get(Uri.parse('http://$ipAdd/users/self'), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('$user:$password'))}'
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        service.setUser(user);
        service.setPassword(password);
        service.setKey('ip', ipAdd);
        service.setKey('userId', data.id.toString());
        service.setKey('permission', data.permission);
        return true;
      } else {
        return false;
      }
    } else {
      service.setKey('ip', ipAdd);
      return user == 'test' && password == 'test';
    }
  }
}
