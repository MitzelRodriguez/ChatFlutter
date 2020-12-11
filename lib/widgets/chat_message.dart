//burbujas de los mensajes

import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uuid;
  final AnimationController animationController;

  const ChatMessage({
    Key key,
    @required this.texto,
    @required this.uuid,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          curve: Curves.easeOut,
          parent: animationController,
        ),
        child: Container(
          child: this.uuid == '123' ? myMessage() : anotherMessage(),
        ),
      ),
    );
  }

//Disenno burbujas
  Widget myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 7),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Color(0xff4D9Ef6),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget anotherMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 7, right: 50),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.black),
        ),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
