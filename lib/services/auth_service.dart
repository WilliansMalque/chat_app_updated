import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chat_app_updated/global/environment.dart';
import 'package:chat_app_updated/helpers/mostrar_alerta.dart';
import 'package:chat_app_updated/models/login_response.dart';
import 'package:chat_app_updated/models/usuario.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario; // Declarado como late
  bool _autenticando = false;

  final _storage = FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(
      Uri.parse('${Environment.apiUrl}login'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      autenticando = false;
      return true;
    } else {
      autenticando = false;
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      Uri.parse('${Environment.apiUrl}login/new'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      usuario = registerResponse.usuario;

      await _guardarToken(registerResponse.token);

      autenticando = false;
      return true;
    } else {
      autenticando = false;
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<Map<String, dynamic>> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    try {
      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}login/renew'),
        headers: {'x-token': token ?? ''},
      );

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;

        await _guardarToken(loginResponse.token);
        return {'ok': true};
      } else {
        logOut();
        return {'ok': false};
      }
    } catch (e) {
      print('Error: $e');
      logOut();
      return {'ok': false, 'msg': e.toString()};
    }
  }

  Future _guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    await _storage.delete(key: 'token');
  }
}
