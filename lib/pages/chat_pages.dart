import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:realtime_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];

  bool _writing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                'Uno',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 17,
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              'Maria Flores',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, i) => _messages[i],
                reverse: true,
              ),
            ),

            Divider(height: 1),

            //CAJA DE TEXTO
            Container(
              child: _inputChat(),
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (texto) {
                  setState(
                    () {
                      if (texto.trim().length > 0) {
                        _writing = true;
                      } else {
                        _writing = false;
                      }
                    },
                  );
                },
                //Linea negra
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),

            //Boton de enviaf
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS ? _cupertinoButton() : _androidButton(),
            ),
          ],
        ),
      ),
    );
  }

  //Boton enviar iOS
  CupertinoButton _cupertinoButton() => CupertinoButton(
        child: Text('Enviar'),
        onPressed: _writing ? () => _handleSubmit(_textController.text) : null,
      );

  //Boton enviar android
  _androidButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.blue,
        ),
        child: IconButton(
          // highlightColor: Colors.transparent,
          // splashColor: Colors.transparent,
          icon: Icon(
            Icons.send,
          ),
          onPressed:
              _writing ? () => _handleSubmit(_textController.text) : null,
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();

    //Ingresar nuevo mensaje
    final newMessage = new ChatMessage(
      uuid: '123',
      texto: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });
  }

  @override
  void dispose() {
    //off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
