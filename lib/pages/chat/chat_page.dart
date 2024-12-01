import 'dart:io';

import 'package:chat_app_updated/models/mensajes_reponse.dart';
import 'package:chat_app_updated/services/auth_service.dart';
import 'package:chat_app_updated/services/chat_service.dart';
import 'package:chat_app_updated/services/socket_service.dart';
import 'package:chat_app_updated/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _textCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);
    cargarHistorial(chatService.usuarioPara?.uid ?? '');
  }

  void cargarHistorial(String usuarioId) async {
    if (usuarioId.isEmpty) return;

    final List<Mensaje> chat = await chatService.getChat(usuarioId);

    final history = chat.map((m) => ChatMessage(
          texto: m.mensaje,
          uid: m.de,
          createdAt: m.createdAt ?? DateTime.now(),
          animationController: AnimationController(
            vsync: this,
            duration: Duration.zero,
          )..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    final message = ChatMessage(
      texto: payload['mensaje'] ?? '',
      uid: payload['de'] ?? '',
      createdAt: DateTime.tryParse(payload['createdAt'] ?? '') ?? DateTime.now(),
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212), // Fondo oscuro
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                usuarioPara?.nombre.substring(0, 2) ?? '',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              backgroundColor: Colors.blueGrey,
              maxRadius: 14,
            ),
            SizedBox(height: 2),
            Text(
              usuarioPara?.nombre ?? '',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: const Color(0xFF1E1E1E), // Fondo oscuro del cuerpo
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            Container(color: const Color(0xFF1E1E1E), child: _inputChat()),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textCtrl,
                onSubmitted: _handleSubmit,
                onChanged: (texto) {
                  setState(() {
                    _estaEscribiendo = texto.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: _focusNode,
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar', style: TextStyle(color: Colors.blue)),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textCtrl.text.trim())
                          : null,
                    )
                  : IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textCtrl.text.trim())
                            : null,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String texto) {
    if (texto.trim().isEmpty) return;

    _textCtrl.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.usuario?.uid ?? '',
      texto: texto,
      createdAt: DateTime.now(),
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );

    setState(() {
      _messages.insert(0, newMessage);
      _estaEscribiendo = false;
    });

    newMessage.animationController.forward();

    socketService.emit('mensaje-personal', {
      'de': authService.usuario?.uid,
      'para': chatService.usuarioPara?.uid,
      'mensaje': texto,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    for (final message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
