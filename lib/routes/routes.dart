//mapa de Rutas de la aplicacion
import 'package:flutter/material.dart';

import 'package:realtime_chat/pages/chat_pages.dart';
import 'package:realtime_chat/pages/loading_page.dart';
import 'package:realtime_chat/pages/login_page.dart';
import 'package:realtime_chat/pages/register_pages.dart';
import 'package:realtime_chat/pages/usuarios_page.dart';

final Map<String,Widget Function(BuildContext)>appRoutes = {

  'usuarios': (_) => UsuariosPage(),
  'registro': (_) => RegistrerPage(),
  'login'   : (_) => LoginPage(),
  'loading' : (_) => LoadingPage(),
  'chat'    : (_) => ChatPage(),
};