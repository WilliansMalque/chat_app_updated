import 'dart:convert';
import 'package:chat_app_updated/models/usuario.dart';

UsuariosResponse usuariosResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  UsuariosResponse({
    required this.ok,
    required this.usuarios,
    required this.desde,
  });

  final bool ok;
  final List<Usuario> usuarios;
  final int desde;

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) {
    return UsuariosResponse(
      ok: json["ok"] ?? false,
      usuarios: (json["usuarios"] as List<dynamic>?)
              ?.map((x) => Usuario.fromJson(x))
              .toList() ??
          [],
      desde: json["desde"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": usuarios.map((x) => x.toJson()).toList(),
        "desde": desde,
      };
}
