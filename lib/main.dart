import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Rutas
import 'package:realtime_chat/routes/routes.dart';

//Providers
import 'package:realtime_chat/services/auth_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //no se necesita el context
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'login',
        routes: appRoutes,
      ),
    );
  }
}
