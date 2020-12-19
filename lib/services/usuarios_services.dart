import 'package:http/http.dart' as http;

import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/models/usuarios_response.dart';
import 'package:realtime_chat/services/auth_services.dart';

import 'package:realtime_chat/global/environment.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuarios', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
