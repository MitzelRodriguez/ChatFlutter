import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/mensajes_response.dart';

import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/services/auth_services.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara; //usuario para quien van los mensajes

//Future que retorna una lista de mensajes
  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http.get(
      '${Environment.apiUrl}/mensajes/$usuarioID',

      //Especificar los headers
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      },
    );

    //Mapear respuesta
    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
