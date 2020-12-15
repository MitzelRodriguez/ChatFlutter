import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:realtime_chat/global/enviroment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  //Crear storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Getters del token estaticos
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  //Metodo que retorna el future
  // ignore: missing_return
  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    //obtener el payload
    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      '${Enviroment.apiUrl}/login',
      //Argumentos a mandar
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.autenticando = false;
    //todo correcto
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  // ignore: missing_return
  Future registro(String nombre, String email, String password) async {
    this.autenticando = true;

    //obtener el payload
    final data = {'nombre': nombre, 'email': email, 'password': password};

    final resp = await http.post(
      '${Enviroment.apiUrl}/login/new',
      //Argumentos a mandar
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.autenticando = false;
    //todo correcto
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final resp = await http.get(
      '${Enviroment.apiUrl}/login/renew',
      headers: {'Content-Type': 'application/json', 'x-token': token},
    );

    //todo correcto
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      this.logout(token);
      return false;
    }
  }

  //Guardar token
  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  //Eliminacion de Token
  Future logout(String token) async {
    return await _storage.delete(key: token);
  }
}
