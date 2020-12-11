import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
//Argumentos
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

//Propiedades que siempre se necesitan manejar llevan @required
  const CustomInput({
    Key key,
    @required this.icon,
    @required this.placeholder,
    @required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(0, 5),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: TextField(
        controller: this.textController,
        autocorrect: false, //desactiva autocompletado
        keyboardType: this.keyboardType,
        obscureText: this.isPassword,
        decoration: InputDecoration(
          icon: Icon(this.icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.placeholder,
        ),
      ),
    );
  }
}
