import 'package:http/http.dart' as http;
import 'package:chat_app_updated/models/usuario.dart';
import 'package:chat_app_updated/models/usuarios_response.dart';
import 'package:chat_app_updated/services/auth_service.dart';
import 'package:chat_app_updated/global/environment.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}usuarios'), // Convertir la URL a Uri
        headers: {
          'Content-Type': 'application/json', // Corrige el tipo de Content-Type
          'x-token': await AuthService.getToken() ?? '', // Maneja tokens nulos
        },
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      print('Error al obtener usuarios: $e'); // Agrega logging para errores
      return [];
    }
  }
}
