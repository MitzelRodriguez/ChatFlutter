import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:realtime_chat/widgets/boton_azul.dart';
import 'package:realtime_chat/widgets/custom_input.dart';
import 'package:realtime_chat/widgets/labels.dart';
import 'package:realtime_chat/widgets/logo.dart';

class RegistrerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  title: 'Registro',
                ),
                _Form(),
                Labels(
                  ruta: 'login',
                  titulo: 'Ya tienes una cuenta?',
                  subtitulo: 'Ingresa ahora!',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Formulario de TextFields
class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre de Usuario',
            textController: nombreController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_open_outlined,
            placeholder: 'Password',
            textController: passController,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Crear Cuenta',
            onPressed: () {
              print(emailController.text);
              print(passController.text);
            },
          ),
        ],
      ),
    );
  }
}
