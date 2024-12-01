import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app_updated/global/environment.dart';
import 'package:chat_app_updated/models/mensajes_reponse.dart';
import 'package:chat_app_updated/models/usuario.dart';

import 'auth_service.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara; // Declarado como late

  Future<List<Mensaje>> getChat(String usuarioId) async {
    try {
      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}mensajes/$usuarioId'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? '',
        },
      );

      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;
    } catch (e) {
      print('Error al obtener mensajes: $e');
      return [];
    }
  }
}
