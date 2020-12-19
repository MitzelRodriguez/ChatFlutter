import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//models
import 'package:realtime_chat/models/mensajes_response.dart';

//Provider servicios
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_services.dart';
import 'package:realtime_chat/services/auth_services.dart';

//Widgets
import 'package:realtime_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _writing = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _listenMessage);
    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  //Escuchar mensaje
  void _listenMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'],
      uuid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  //Cargar lista de mensajes
  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat.map((m) => new ChatMessage(
          texto: m.mensaje,
          uuid: m.de,
          animationController: new AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 17,
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              usuarioPara.nombre,
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
      uuid: authService.usuario.uid,
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

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto,
    });
  }

  @override
  void dispose() {
    //off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
