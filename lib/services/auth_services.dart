import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/enviroment.dart';

class AuthService with ChangeNotifier {
//Metodo que retorna el future
  Future login(String email, String password) async {
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

    print(resp.body);
  }
}
