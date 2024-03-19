import 'dart:convert';
import 'dart:io';

class UserSessionService {
  static const String _userKey = 'user';
  static const String _passwordKey = 'password';
  static UserSessionService? _instance;
  Map<String, String> keys = {};

  static UserSessionService instance() {
    UserSessionService instance = _instance ?? UserSessionService();
    _instance ??= instance;
    return instance;
  }

  Map<String, String> getHeader() {
    return {
      HttpHeaders.authorizationHeader:
          'Basic ${base64Encode(utf8.encode('${getUser()}:$getPassword()'))}'
    };
  }

  void setKey(String key, String val) {
    keys[key] = val;
  }

  String? getKey(String key) {
    return keys[key];
  }

  void setUser(String username) {
    keys[_userKey] = username;
  }

  String? getUser() {
    return keys[_userKey];
  }

  void setPassword(String password) {
    keys[_passwordKey] = password;
  }

  String? getPassword() {
    return keys[_passwordKey];
  }
}
